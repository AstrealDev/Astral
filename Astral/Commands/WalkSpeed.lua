local cmd = {};

cmd.Name 			= "WalkSpeed";
cmd.UsageString		= "speed me 100";
cmd.Usages			= {"walkspeed", "speed", "ws"};
cmd.RequiredArgs	= 2;
cmd.ArgsFormat		= {"pt", "nt"};
cmd.MinimumRank 	= 1;
cmd.Execute			= function(executer, targets, speed)
	print(targets[1], targets[2], speed[1], speed[2]);
end

return cmd;