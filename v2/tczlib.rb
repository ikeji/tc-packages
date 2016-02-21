require 'tmpdir'

PKGDIR = File::expand_path(File.dirname($0))
ROOT_DIR = File.dirname(__FILE__) + "/"
PKGNAME =
  File.expand_path($0).
  gsub(/^#{ROOT_DIR}/,"").
  gsub(/\.pkg$/,"").
  gsub("/","_")
DISTFILES = ROOT_DIR + "/distfiles/"
REPOSITORY = ROOT_DIR + "/repository/"
OUTPUT_DIR = ROOT_DIR + "/build/"
TEMP_DIR = Dir.mktmpdir
PREPARE_ROOT = TEMP_DIR + "/pkgroot/"

def exec_wrap(command)
  puts "\e[32mTCZBUILD\e[0m: #{command}"
  rv = system command
  if !rv
    exit -1
  end

  if (ARGV.include?("-d"))
    print "continue?"
    r = STDIN.gets.chomp
    if (r == "s")
      system "sh"
    end
  end
end

def load_dependency(pkgnames)
  exec_wrap("tce-load -w compiletc make #{pkgnames.join(" ")}")
  exec_wrap("tce-load -ic compiletc make #{pkgnames.join(" ")} | tee #{TEMP_DIR}/stdout")
  File.open("#{TEMP_DIR}/stdout") do |r|
    if r.read.include? "not found!"
      puts "package error"
      exit -1
    end
  end
end

def load_dependency_local(pkgnames)
  Dir.chdir OUTPUT_DIR do
    exec_wrap("tce-load -ic #{pkgnames.join(" ")} | tee #{TEMP_DIR}/stdout")
    File.open("#{TEMP_DIR}/stdout") do |r|
      if r.read.include? "not found!"
        puts "package error"
        exit -1
      end
    end
  end
end

def fetch_distfiles(filename, url)
  Dir.chdir DISTFILES do
    if (!File.exists?(filename))
      exec_wrap "wget -O #{filename} #{url}"
    end
  end
end

def md5sum(filename, md5)
  Dir.chdir DISTFILES do
    if !system "echo '#{md5}  #{filename}' | md5sum -c"
      puts "Checksum error!"
      system "md5sum #{filename}"
      exit -1
    end
  end
end

def unpack(filename)
  Dir.chdir TEMP_DIR do
    exec_wrap "tar xvf #{DISTFILES}/#{filename}"
  end
end

def configure(pkg, opts=[])
  Dir.chdir TEMP_DIR do
    Dir.chdir pkg do
      exec_wrap "./configure #{opts.join(" ")}"
    end
  end
end

def make(pkg, tgt=[])
  Dir.chdir TEMP_DIR do
    Dir.chdir pkg do
      exec_wrap "make #{tgt.join(" ")}"
    end
  end
end

def install(pkg, opts=[])
  Dir.chdir TEMP_DIR do
    Dir.chdir pkg do
      exec_wrap "mkdir -p #{PREPARE_ROOT}"
      exec_wrap "make DESTDIR=#{PREPARE_ROOT} #{opts.join(" ")} install"
    end
  end
end

def scrub(additional_files = [])
  Dir.chdir PREPARE_ROOT do
    exec_wrap("find > #{TEMP_DIR}/before_scrub")
    exec_wrap("rm -rf usr/local/share/man")
    exec_wrap("rm -rf usr/local/share/doc")
    exec_wrap("rm -rf usr/local/share/info")
    exec_wrap("rm -rf usr/local/share/aclocal")
    exec_wrap("rm -rf usr/local/man")
    exec_wrap("rm -rf usr/local/include")
    exec_wrap("rm -rf usr/local/lib/*.la")
    exec_wrap("rm -rf usr/local/lib/*.a")
    exec_wrap("rm -rf usr/local/lib/pkgconfig")
    additional_files.each do |f|
      exec_wrap("rm -rf #{f}")
    end
    if block_given?
      yield
    end
    exec_wrap("find . -type d -empty -delete")
    exec_wrap("find > #{TEMP_DIR}/after_scrub")
    puts "\e[32mTCZBUILD\e[0m: List of scrubed files:"
    system("diff #{TEMP_DIR}/before_scrub #{TEMP_DIR}/after_scrub")
    if (ARGV.include?("-s"))
      system "sh"
    end
  end
end

def scrub_for_dev(exclude_bin = nil)
  Dir.chdir PREPARE_ROOT do
    exec_wrap("find > #{TEMP_DIR}/before_scrub")
    exec_wrap("rm -rf usr/local/share/man")
    exec_wrap("rm -rf usr/local/share/doc")
    exec_wrap("rm -rf usr/local/share/info")
    exec_wrap("rm -rf usr/local/man")
    if exclude_bin
      exec_wrap("find usr/local/bin -type f | grep -v #{exclude_bin} | xargs rm -rf")
    else
      exec_wrap("rm -rf usr/local/bin")
    end
    exec_wrap("rm -rf usr/local/sbin")
    exec_wrap("rm -rf usr/local/lib/*.so*")
    if block_given?
      yield
    end
    exec_wrap("find . -type d -empty -delete")
    exec_wrap("find > #{TEMP_DIR}/after_scrub")
    puts "\e[32mTCZBUILD\e[0m: List of scrubed files:"
    system("diff #{TEMP_DIR}/before_scrub #{TEMP_DIR}/after_scrub")
    if (ARGV.include?("-s"))
      system "sh"
    end
  end
end

def makepkg()
  puts "\e[32mTCZBUILD\e[0m: List of files we pack."
  Dir.chdir PREPARE_ROOT do
    exec_wrap "find *"
    exec_wrap "find * > #{OUTPUT_DIR}/#{PKGNAME}.tcz.list"
  end
  Dir.chdir OUTPUT_DIR do
    exec_wrap "rm -f #{PKGNAME}.tcz"
    exec_wrap "mksquashfs #{PREPARE_ROOT} #{PKGNAME}.tcz"
    exec_wrap "md5sum #{PKGNAME}.tcz > #{PKGNAME}.tcz.md5.txt"
    puts "\e[32mTCZBUILD\e[0m: gererated #{PKGNAME}.tcz"
    exec_wrap "ls -lh #{PKGNAME}.tcz"
  end
end

def makedep(deps)
  Dir.chdir OUTPUT_DIR do
    File.open("#{PKGNAME}.tcz.dep", "w") do|w|
      deps.each do |d|
        w.puts "#{d}.tcz"
      end
    end
  end
end

def buildpkg(pkg)
  option = ""
  if ARGV.include? "-s"
    option += "-s"
  elsif ARGV.include? "-d"
    option += "-d"
  end

  exec_wrap <<-EOL
    docker run \
            -t -i --rm \
            -v `pwd`:/work \
            -v `pwd`/repository:/tmp/tce/optional \
            tatsushid/tinycore:6.4-x86 \
            sh -c ' \
              tce-load -w ruby-2.2 && \
              tce-load -ic ruby-2.2 && \
              /work/#{pkg}.pkg #{option}'
  EOL
end

def buildpack()
  Dir.chdir OUTPUT_DIR do
    exec_wrap("tar zcvf #{ROOT_DIR}/all.tgz *")
  end
end
