require "./object"

module Git
  class Signature < C_Pointer
    @value : Pointer(LibGit::Signature)
    @need_free = false

    protected def initialize
      @value = uninitialized LibGit::Signature
    end

    protected def initialize(@value)
    end

    def initialize(name : String, email : String, time : Time)
      @need_free = true
      nerr(LibGit.signature_new(out @value, name, email, time.to_unix, 0))
    end

    def initialize(name : String, email : String)
      @need_free = true
      nerr(LibGit.signature_now(out @value, name, email))
    end

    def name
      String.new(@value.value.name)
    end

    def email
      String.new(@value.value.email)
    end

    def epoch_time
      @value.value.when.time
    end

    def time
      Time.unix(epoch_time)
    end

    def finalize
      if @need_free
        LibGit.signature_free(@value)
      end
    end
  end

  class CommitData
    getter message : String
    getter parents : Array(Commit)
    getter tree : Tree
    getter committer : Signature | Nil
    getter author : Signature | Nil
    getter update_ref : String | Nil

    def initialize(@message : String, @parents : Array(Commit), @tree : Tree,
                   @committer : Signature | Nil, @author : Signature | Nil,
                   @update_ref : String | Nil = nil)
    end

    def parent_count
      @parents.size
    end
  end

  class AmendData
    getter message : String | Nil
    getter tree : Tree | Nil
    getter committer : Signature | Nil
    getter author : Signature | Nil
    getter update_ref : String | Nil

    def initialize(@message : String | Nil = nil, @tree : Tree | Nil = nil,
                   @committer : Signature | Nil = nil, @author : Signature | Nil = nil,
                   @update_ref : String | Nil = nil)
    end
  end

  class Commit < Object
    @value : LibGit::Commit

    def amend(data : AmendData)
      update_ref = nil.as(Pointer(UInt8))
      if !(v = data.update_ref).nil?
        update_ref = v.to_unsafe
      end

      author = nil.as(LibGit::Signature*)
      if !(v = data.author).nil?
        author = v.to_unsafe
      end

      committer = nil.as(LibGit::Signature*)
      if !(v = data.committer).nil?
        committer = v.to_unsafe
      end

      message = nil.as(Pointer(UInt8))
      if !(v = data.message).nil?
        message = v.to_unsafe
      end

      tree = nil.as(LibGit::Tree)
      if !(v = data.tree).nil?
        tree = v.to_unsafe
      end

      nerr(LibGit.commit_amend(out oid, @value, update_ref, author, committer, nil, message, tree))

      Oid.new(oid)
    end

    def sha
      oid = LibGit.commit_id(@value)
      p = LibGit.oid_tostr_s(oid)
      String.new(p)
    end

    def epoch_time
      LibGit.commit_time(@value)
    end

    def time
      Time.unix(epoch_time)
    end

    def author
      Signature.new(LibGit.commit_author(@value))
    end

    def committer
      Signature.new(LibGit.commit_committer(@value))
    end

    def message
      String.new(LibGit.commit_message(@value))
    end

    def parents
      parent_count.times.map { |i| parent(i) }.to_a
    end

    def parent_count
      LibGit.commit_parentcount(@value)
    end

    def tree
      nerr(LibGit.commit_tree(out t, @value))
      Tree.new(t)
    end

    def parent
      parent(0)
    end

    def parent(n : Int)
      nerr(LibGit.commit_parent(out parent, @value, n))
      Commit.new(parent)
    end

    def diff
      self.tree.diff(parents.first.tree)
    end

    def diff(tree : Tree)
      self.tree.diff(tree)
    end

    def diff(commit : Commit)
      self.tree.diff(commit.tree)
    end

    def to_s(io)
      io << sha
    end

    def finalize
      LibGit.commit_free(@value)
    end

    def self.lookup(repo : Repo, oid : Oid)
      nerr(LibGit.commit_lookup(out commit, repo, oid.p))
      Commit.new(commit)
    end

    def self.lookup(repo : Repo, sha : String)
      if sha.size == 40
        self.lookup(repo, Git::Oid.new(sha))
      else
        nerr(LibGit.commit_lookup_prefix(out commit, repo, Git::Oid.new(sha).p, sha.size))
        Commit.new(commit)
      end
    end

    def self.create(repo : Repo, data : CommitData)
      author = data.author.nil? ? Signature.new : data.author.as(Signature)
      committer = data.committer.nil? ? Signature.new : data.committer.as(Signature)
      parents = data.parents.map(&.to_unsafe)

      update_ref = nil.as(Pointer(UInt8))
      if !(v = data.update_ref).nil?
        update_ref = v.to_unsafe
      end

      nerr(LibGit.commit_create(out oid, repo, update_ref, author,
        committer, nil, data.message, data.tree, data.parent_count, parents))

      Oid.new(oid)
    end

    def self.create_to_s(repo : Repo, data : CommitData)
      author = data.author.nil? ? Signature.new : data.author.as(Signature)
      committer = data.committer.nil? ? Signature.new : data.committer.as(Signature)
      parents = data.parents.map(&.to_unsafe)

      if !data.update_ref.nil?
        raise "can't use update_ref in create_s"
      end

      buf = LibGit::Buf.new
      nerr(LibGit.commit_create_buffer(pointerof(buf), repo, author, committer, nil,
        data.message, data.tree, data.parent_count, parents))

      String.new(buf.ptr)
    end
  end
end
