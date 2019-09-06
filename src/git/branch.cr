require "./reference"

module Git
  alias BranchType = LibGit::BranchT

  class Branch < Reference
    def name
      nerr(LibGit.branch_name(out b_name, @value))
      String.new(b_name)
    end

    def head?
      LibGit.branch_is_head(@value) == 1
    end
  end

  class BranchCollection < NoError
    include Iterable(Branch)

    def initialize(@repo : Repo)
    end

    def [](name)
      err, branch = ref_from_name(name)
      nerr(err)
      Branch.new(branch.not_nil!)
    end

    def each(b_type : BranchType = BranchType::All)
      BranchIterator.new(@repo, b_type)
    end

    def each_name(b_type : BranchType = BranchType::All)
      each(b_type).map(&.name)
    end

    def create(name : String, target : Commit, force : Bool = false)
      nerr(LibGit.branch_create(out ref, @repo, name, target, force))
      Branch.new(ref)
    end

    private def ref_from_name(name)
      branch = uninitialized LibGit::Reference

      if name.starts_with?("refs/heads/") || name.starts_with?("refs/remotes/")
        err = LibGit.reference_lookup(pointerof(branch), @repo, name)
        return err, branch
      end

      err = LibGit.branch_lookup(pointerof(branch), @repo, name, BranchType::Local)
      if err == 0 && err != LibGit::ErrorCode::NotFound.value
        return err, branch
      end

      err = LibGit.branch_lookup(pointerof(branch), @repo, name, BranchType::Remote)
      if err == 0 && err != LibGit::ErrorCode::NotFound.value
        return err, branch
      end

      err = LibGit.reference_lookup(pointerof(branch), @repo, "refs/" + name)
      return err, branch
    end

    private class BranchIterator < NoError
      include Iterator(Branch)

      def initialize(repo : Repo, b_type : BranchType)
        nerr(LibGit.branch_iterator_new(out @iter, repo, b_type))
      end

      def next
        r = LibGit.branch_next(out ref, out branch_next, @iter)

        if r == LibGit::ErrorCode::Iterover.value
          stop
        else
          nerr(r)

          Branch.new(ref)
        end
      end

      def finalize
        LibGit.branch_iterator_free(@iter)
      end
    end
  end
end
