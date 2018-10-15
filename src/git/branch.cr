require "./reference"

module Git
  alias BranchType = LibGit::BranchT

  class Branch < Reference
    def name
      nerr(LibGit.branch_name(out b_name, @value))
      String.new(b_name)
    end
  end

  class BranchCollection < NoError
    include Enumerable(Branch)

    def initialize(@repo : Repo)
    end

    def [](name)
      nerr(LibGit.reference_lookup(out ref, @repo, name))
      Branch.new(ref)
    end

    def each(b_type : BranchType = BranchType::All)
      BranchIterator.new(@repo, b_type)
    end

    def each_name(b_type : BranchType = BranchType::All)
      each(b_type).map(&.name)
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
