local gst = xyy_gst:get_mod()

local function UI_Component_destroy( component, divorce )
    if is_uicomponent( component ) then
        divorce = not not divorce
        if divorce then
            local parent = component:Parent()

            if is_uicomponent( parent ) then
                parent:Divorce( component:Address() )
            end
        end
    end
end

--设置一个ui对象的大小
local function UI_Component_resize( component, width, height, can_resize )
    if is_uicomponent( component ) then
        if (not not can_resize) then
            component:SetCanResizeHeight(true)
            component:SetCanResizeWidth(true)
            component:Resize(width, height)
            component:SetCanResizeHeight(false)
            component:SetCanResizeWidth(false)
        else
            component:Resize(width, height)
        end
    end
end

local function UI_Component_coordinates( component )
    if is_uicomponent( component ) then
        local x, y = component:Position()
        local w, h = component:Dimensions()
        return x, y, w, h
    end
    return 0, 0, 0, 0
end

--移动相对位置
local function UI_Component_move_relative( component, anchor, relative_x, relative_y, is_margin )
    is_margin = not not is_margin

    if is_uicomponent( component ) and is_uicomponent( anchor ) then
        local x, y, w, h = UI_Component_coordinates( anchor )
        if is_margin then
            component:MoveTo(x + w + relative_x, y + h + relative_y)
        elseif is_uicomponent( anchor ) then
            component:MoveTo(x + relative_x, y + relative_y)
        end
    end
end



-----------------------------------------------------------------
--  Register
-----------------------------------------------------------------

gst.UI_Component_destroy = UI_Component_destroy
gst.UI_Component_resize = UI_Component_resize
gst.UI_Component_coordinates = UI_Component_coordinates
gst.UI_Component_move_relative = UI_Component_move_relative

return gst