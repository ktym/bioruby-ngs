class Mira < Thor

  class Pre < Mira
    
    # define tasks for pre-processing
    {:sff => "sff_extract", :ssaha => "ssaha2"}.each_pair do |name,prog|
      Pre.class_eval do
        desc "#{name} FILE", "run #{prog} with custom options"
        define_method name do
          opts = Bio::NGS::NativeOptions.new # bypass Thor arguments parsing
          bin = Bio::NGS::Utils.os_binary(prog)
          puts Bio::Command.query_command [bin]+opts.args
          Bio::NGS::Record.save("mira:pre:"+name.to_s,opts.args)
        end
      end
    end
    
  end
  
  class Run < Mira
    
    # define tasks for basic Mira jobs (useful for the end-user to see the different commands)
    ["genome","denovo","draft","sanger","454","solexa","solid"].each do |job|
      Run.class_eval do 
        desc job, "run Mira with --job="+job
        define_method job.to_sym do
          opts = Bio::NGS::NativeOptions.new # bypass Thor arguments parsing
          bin = Bio::NGS::Utils.os_binary("mira")
          puts Bio::Command.query_command [bin, "--job="+job]+opts.args
          Bio::NGS::Record.save("mira:run:"+job,opts.args)
        end
      end
    end
    
    # handle tasks for complex jobs definition (i.e --job=denovo,solexa,normal,454)
    def method_missing(task, *args)
      opts = Bio::NGS::NativeOptions.new # bypass Thor arguments parsing
      bin = Bio::NGS::Utils.os_binary("mira")
      puts Bio::Command.query_command [bin, "--job="+task.to_s]+opts.args
      Bio::NGS::Record.save("mira:run:"+task.to_s,opts.args)
    end
    
  end
  
end
  