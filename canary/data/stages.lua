-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 100,
		multiplier = 200,
	},
	{
		minlevel = 101,
		maxlevel = 500,
		multiplier = 100,
	},
	{
		minlevel = 501,
		maxlevel = 1000,
		multiplier = 50,
	},
	{
		minlevel = 1001,
		multiplier = 25,
	},
}

skillsStages = {
	{
		minlevel = 10,
		multiplier = 50, -- 50x flat for all skill levels
	},
}

magicLevelStages = {
	{
		minlevel = 0,
		multiplier = 30, -- 30x flat for all magic levels
	},
}
