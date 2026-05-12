-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 100,
		multiplier = 150,
	},
	{
		minlevel = 101,
		maxlevel = 500,
		multiplier = 75,
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
		maxlevel = 125,
		multiplier = 30,
	},
	{
		minlevel = 126,
		multiplier = 15,
	},
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 110,
		multiplier = 20,
	},
	{
		minlevel = 111,
		multiplier = 10,
	},
}
