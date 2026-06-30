allow_defined_top = true

exclude_files = {".luacheckrc"}

globals = {
	"one_for_all",
}

read_globals = {
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Luanti
	"minetest", "core",
	"vector", "ItemStack",
	"dump", "DIR_DELIM",
	"VoxelArea", "Settings",
	"PcgRandom", "VoxelManip",
	"PseudoRandom",
}