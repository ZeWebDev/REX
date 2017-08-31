if ARGV.size < 1
  help()
end

directory = Dir.current + "/"

args = {
  :regex => //,
  :string => ""
}

options = {
  :keep => false,
  :exists => "ask",
  :folders => false,
  :recursive => false,
  :silent => false
}

ARGV.each do |arg|

  if arg[0] == '-'

    if match = arg.match(/^(-{1,2})([^=]*)=?(.+)?/)
      groups  = match.captures

      hyphens = groups[0]

      option  = groups[1]

      if groups.size > 2
        path = groups[2]
      end

      if hyphens && option # Avoid compiler error

        if option.size == 1 && arg[1] == '-'

          puts "Error: Invalid option --#{option}"
          puts "Use a single - for short hand options"
          exit 1

        elsif option.size > 1 && arg[1] != '-'

          puts "Error: Invalid option -#{option}"
          puts "Use -- for full option names"
          exit 1

        end


        case option
        when "d", "directory"

          if path

            if path[0] == '/'

              directory = path

            else

              directory += path

            end

            if File.exists? directory

              if !File.directory? directory

                puts "Error: Path is not a directory"
                exit 1

              end

            else

              puts "Error: No such file or directory #{path}"
              exit 1

            end

            if directory[-1] != "/"

              directory += "/"

            end

          else

            puts "Error: #{hyphens + option} must specify directory"
            puts "Example usage: #{hyphens + option}:/path/to/directory"
            exit 1

          end

        when "e", "exists"

          if path

            if ["ask","skip","add","cancel"].includes? path

              options[:exists] = path

            else

              puts "Error: #{hyphens + option}=#{path} invalid option"
              puts "Options are ask(default), skip, add, cancel"
              exit 1

            end

          else

            puts "Error: #{hyphens + option} must specify option"
            puts "Options are ask(default), skip, add, cancel"
            exit 1

          end

        when "k", "keep"

          options[:keep] = true

        when "h", "help"

          help()


        when "r", "recursive"

          options[:recursive] = true

        when "f", "folders"

          options[:folders] = true

        when "s", "silent"

          options[:silent] = true

        else

          puts "Error invalid option #{hyphens + option}"
          exit 0

        end

      end

    end

  else

    if args[:regex] == //

      args[:regex] = Regex.new arg

    elsif args[:string] == ""

      args[:string] = arg

    else

      puts "Too many arguments"
      exit 1

    end

  end

end



def help

  puts "
Bulk rename files with regex

Replaces every match with a provided string

Usage: rename [options] Regex String

Options:
  -d, --directory=directory     the path to the target directory
  -e, --exists=[option]         choose what happens if file already exists
                                options are ask(default), skip, add, cancel
  -f, --folders                 rename folders
  -h, --help                    show this help
  -k, --keep                    keep file extensions
  -r, --recursive               search files in subfolders
  -s, --silent                  reduces output by ommiting filename changes

Notes:
  Backslashes must either be escaped or in quotes
  Anything with whitespaces must be in quotes

Examples:
  rename -e \\\\.html$ .php
  rename -r -f \"file\" \"file name\"

"

  exit 1

end

def check (orig, ext, try, name=orig)

  if File.exists? name + ext

      try += 1

      try = check(orig, ext, try, "#{orig} #{try}")


  end

  return try

end

puts "Renaming files..."

def rename (directory,args,options)

  Dir.glob(directory + "*").sort.each do |f|

    if File.directory?(f)
      if options[:recursive]

        rename(f + "/",args,options)

      end

      if !options[:folders]

        next

      end

    end


    ext = File.extname(f)

    base = File.basename(f, ext)

    file = base + ext


    if options[:keep]

      base = base.sub(args[:regex], args[:string])

      newName = base + ext

    else

      newName = file.sub(args[:regex], args[:string])

      ext = File.extname(newName)

      base = File.basename(newName, ext)

    end


    if file != newName

      if (try = check(directory + base,ext, 1)) > 1

        ask = "ask"

        if options[:exists] == "ask"

          puts "File #{newName} already exists [(S)kip/(a)dd/(o)verwrite/(c)ancel]"

          ask = gets


          while ask && !ask.match /^$|^S(kip)?$|^A(dd)?$|^O(verwrite)?$|^C(ancel)?$/i

            puts "Invalid option"

            ask = gets

          end

        end

        if ask # Avoid compiler error

          if options[:exists] == "skip" || ask.match /^$|^S(kip)?$/i

            if !options[:silent]

              puts "Skipped #{file}"

            end

            next

          elsif options[:exists] == "add" || ask.match /^A(dd)?$/i

            newName = "#{base} #{try}#{ext}"

          elsif options[:exists] == "cancel" || ask.match /^C(ancel)?$/i

            puts "Operation cancelled"
            exit 1

          end

        end

      end

      File.rename(f, directory + newName)

      if !options[:silent]

        puts file + " to " + newName

      end

    end

  end

end

rename(directory,args,options)


puts "Renaming complete."
