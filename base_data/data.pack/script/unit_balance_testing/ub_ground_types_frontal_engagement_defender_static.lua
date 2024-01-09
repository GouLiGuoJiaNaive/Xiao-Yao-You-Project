-------------------------------------------------------------------------------------------------------------------------
--------------------------- Three Kingoms UB - GT Frontal Engagement Defender Static ------------------------------------
------------------------------------------------- Hugh McLaughlin / Nov 2018 --------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

print("GroundTypesFrontalEngagementDefenderStatic: No difference from the non ground type version but we need to specify a different lua file to detect in code, were just including the none ground type file to run that instead")

package.path = package.path .. ";TestData/UnitTesting/?.lua" .. ";data/script/unit_balance_testing/_lib/?.lua" .. ";data/script/unit_balance_testing/?.lua"

force_require("ub_frontal_engagement_defender_static")
