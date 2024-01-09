print("*** Loading region validation... ***");

function validate_regions(region_list)

	local assumptions = {};

	local validated_object = Validated_object:new("Regions", region_list, assumptions);

	return validated_object;
end;


print("*** Region validation loaded... ***");