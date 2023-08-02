/*
* -------------------------
* • Fichier: cl_scoreboard.lua
* • Projet: client
* • Création : Friday, 14th July 2023 8:40:53 pm
* • Auteur : Ekali
* • Modification : Friday, 14th July 2023 8:40:53 pm
* • Destiné à Prisel.fr en V3
* -------------------------
*/

local scoreboardFrame
local iscrolled = 0

function Prisel.Scoreboard.Close()
  if IsValid(scoreboardFrame) then
    scoreboardFrame:AlphaTo(0, 0.1, 0, function()
      scoreboardFrame:Remove()
    end)
  end
end

function Prisel.Scoreboard.Open()
  if IsValid(scoreboardFrame) then
    Prisel.Scoreboard.Close()
  end
  PriselHUD.ActiveLogo = false
  scoreboardFrame = vgui.Create("Prisel.Frame")
  scoreboardFrame:SetSize(DarkRP.ScrW * 0.4, DarkRP.ScrH * 0.7)
  scoreboardFrame:Center()
  scoreboardFrame:SetTitle("")
  scoreboardFrame:ShowCloseButton(false)
  scoreboardFrame:SetTitle("Scoreboard - Prisel.fr")
  scoreboardFrame:MakePopup()
  
  local panelSrc = vgui.Create("DPanel", scoreboardFrame)
  panelSrc:Dock(FILL)
  panelSrc:DockMargin(DarkRP.ScrW * 0.005, DarkRP.ScrH * 0.08, DarkRP.ScrW * 0.005, DarkRP.ScrH * 0.01)
  panelSrc:SetSize(scoreboardFrame:GetWide(), DarkRP.ScrH * 0.06)

  function panelSrc:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, DarkRP.Config.Colors["Secondary"])
  end

  local scrollPlayer = vgui.Create("DScrollPanel", panelSrc)
  scrollPlayer:Dock(FILL)
  scrollPlayer:DockMargin(DarkRP.ScrW * 0.005, DarkRP.ScrH * 0.005, DarkRP.ScrW * 0.005, DarkRP.ScrH * 0.005)
  

  local vbar = scrollPlayer:GetVBar()
  if iscrolled ~= 0 then
    vbar:AnimateTo(iscrolled, 1, 0, -1, function() end)
  end
  vbar:SetHideButtons(true)
  function vbar:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, DarkRP.Library.ColorNuance(DarkRP.Config.Colors["Main"], 10))
    surface.SetDrawColor(DarkRP.Library.ColorNuance(DarkRP.Config.Colors["Main"], 50))
    surface.DrawOutlinedRect(0, 0, w, h)
  end

  function vbar.btnGrip:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, DarkRP.Library.ColorNuance(DarkRP.Config.Colors["Main"], 25))
    surface.SetDrawColor(DarkRP.Library.ColorNuance(DarkRP.Config.Colors["Main"], 50))
    surface.DrawOutlinedRect(0, 0, w, h)
  end

  function scrollPlayer:Paint(w, h)
  end
  
  for k, v in ipairs(player.GetAll()) do
    local panel = vgui.Create("DPanel", scrollPlayer)
    panel:Dock(TOP)
    panel:DockMargin(DarkRP.ScrW * 0.002, DarkRP.ScrH * 0.01, DarkRP.ScrW  * 0.005, 0)
    panel:SetSize(scrollPlayer:GetWide(), DarkRP.ScrH * 0.06)
    panel:SetCursor("hand")

    local playerAvatar = vgui.Create("Prisel.AvatarRounded", panel)
    playerAvatar:SetSize(DarkRP.ScrH * 0.05, DarkRP.ScrH * 0.05)
    playerAvatar:SetPos(DarkRP.ScrW * 0.005, panel:GetTall()/2 - playerAvatar:GetTall()/2)
    playerAvatar:SetPlayer(v, 128)

    local pTall = panel:GetTall()
    

    function panel:Paint(w, h)
      if self.hover then
        draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Library.ColorNuance(DarkRP.Config.Colors["Main"], 50))
      end
      draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors["Main"])

      if LocalPlayer():HasAdminMode() then
        draw.SimpleText(self.Expand and "-" or "+", DarkRP.Library.Font(12), DarkRP.ScrW * 0.36, pTall/2 - DarkRP.ScrH / DarkRP.ScrH, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end
    end

    if not LocalPlayer():HasAdminMode() then
      local playerName = vgui.Create("DLabel", panel)
      playerName:SetSize(DarkRP.ScrW*0.2, panel:GetTall())
      playerName:SetText(v:Nick())
      playerName:SetFont(DarkRP.Library.Font(12, 0, "Montserrat Bold"))
      playerName:SetTextColor(color_white)
      playerName:SetPos(playerAvatar:GetWide() + DarkRP.ScrW * 0.01, panel:GetTall()/2 - playerName:GetTall()/2)

      function playerName:Think()
        if not IsValid(v) then
          panel:Remove()
        end
      end

      local playerPing = vgui.Create("DLabel", panel)
      playerPing:SetSize(DarkRP.ScrW * 0.05, panel:GetTall())
      playerPing:SetText(v:Ping())
      playerPing:SetFont(DarkRP.Library.Font(12, 0, "Montserrat Bold"))
      playerPing:SetTextColor(color_white)
      playerPing:SetPos(DarkRP.ScrW * 0.312, panel:GetTall()/2 - playerPing:GetTall()/2)
      playerPing:SetContentAlignment(6)


      function panel:OnMousePressed()
        SetClipboardText(v:SteamID())
        notification.AddLegacy("SteamID de " .. v:Name().." copié ("..v:SteamID()..")", NOTIFY_GENERIC, 2)
      end
    else
      local playerName = vgui.Create("DLabel", panel)
      playerName:SetSize(DarkRP.ScrW * 0.08, panel:GetTall())
      playerName:SetText(v:Nick())
      playerName:SetFont(DarkRP.Library.Font(12, 0, "Montserrat Bold"))
      playerName:SetTextColor(color_white)
      playerName:SetPos(playerAvatar:GetWide() + DarkRP.ScrW * 0.01, panel:GetTall()/2 - playerName:GetTall()/2)

      local jobName = vgui.Create("DLabel", panel)
      jobName:SetSize(DarkRP.ScrW * 0.11, panel:GetTall())
      jobName:SetText(v:getDarkRPVar("job"))
      jobName:SetFont(DarkRP.Library.Font(12, 0, "Montserrat Bold"))
      jobName:SetTextColor(v:getJobTable().color)
      jobName:SetPos(playerAvatar:GetWide() + DarkRP.ScrW * 0.11, panel:GetTall()/2 - jobName:GetTall()/2)
      jobName:SetContentAlignment(5)

      local playerPing = vgui.Create("DLabel", panel)
      playerPing:SetSize(DarkRP.ScrW * 0.05, panel:GetTall())
      playerPing:SetText(v:Ping())
      playerPing:SetFont(DarkRP.Library.Font(10, 0, "Montserrat Bold"))
      playerPing:SetTextColor(color_white)
      playerPing:SetPos(DarkRP.ScrW * 0.28, panel:GetTall()/2 - playerPing:GetTall()/2)
      playerPing:SetContentAlignment(6)

      local panelPlayer = vgui.Create("DPanel", panel)
      panelPlayer:Dock(FILL)
      panelPlayer:DockMargin(DarkRP.ScrW * 0.005, DarkRP.ScrH * 0.06, DarkRP.ScrW  * 0.005, DarkRP.ScrW * 0.005)

      function panelPlayer:Paint(w, h)
        draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Library.ColorNuance(DarkRP.Config.Colors["Secondary"], 15))
      end

      local iconLayout = vgui.Create("DIconLayout", panelPlayer)
      iconLayout:Dock(FILL)
      iconLayout:DockMargin(DarkRP.ScrW * 0.005, DarkRP.ScrH * 0.005, DarkRP.ScrW  * 0.005, DarkRP.ScrW * 0.005)
      iconLayout:SetSpaceX(DarkRP.ScrW * 0.005)
      iconLayout:SetSpaceY(DarkRP.ScrH * 0.005)

      local buttonTP = vgui.Create("Prisel.Button", iconLayout)
      buttonTP:SetSize(DarkRP.ScrW * 0.08, DarkRP.ScrH * 0.05)
      buttonTP:SetText("Goto")

      function buttonTP:DoClick()
        LocalPlayer():ConCommand("sam goto " .. v:Nick())
      end

      local buttonBring = vgui.Create("Prisel.Button", iconLayout)
      buttonBring:SetSize(DarkRP.ScrW * 0.08, DarkRP.ScrH * 0.05)
      buttonBring:SetText("Bring")

      function buttonBring:DoClick()
        LocalPlayer():ConCommand("sam bring " .. v:Nick())
      end

      local buttonFreeze = vgui.Create("Prisel.Button", iconLayout)
      buttonFreeze:SetSize(DarkRP.ScrW * 0.08, DarkRP.ScrH * 0.05)
      buttonFreeze:SetText(v:sam_get_nwvar("frozen") and "Unfreeze" or "Freeze")
      
      function buttonFreeze:Think()
        if v:sam_get_nwvar("frozen") then
          buttonFreeze:SetText("Unfreeze")
        else
          buttonFreeze:SetText("Freeze")
        end
      end

      function buttonFreeze:DoClick()
        if v:sam_get_nwvar("frozen") then
          LocalPlayer():ConCommand("sam unfreeze " .. v:SteamID())
        else
          LocalPlayer():ConCommand("sam freeze " .. v:SteamID())
        end
      end

      local buttonSpec = vgui.Create("Prisel.Button", iconLayout)
      buttonSpec:SetSize(DarkRP.ScrW * 0.102, DarkRP.ScrH * 0.05)
      buttonSpec:SetText("Spectate")

      function buttonSpec:DoClick()
        LocalPlayer():ConCommand("FSpectate " .. v:UserID())
      end

      local buttonAdminMenu = vgui.Create("Prisel.Button", iconLayout)
      buttonAdminMenu:SetSize(DarkRP.ScrW * 0.13, DarkRP.ScrH * 0.05)
      buttonAdminMenu:SetText("Ouvrir Menu Admin")

      function buttonAdminMenu:DoClick()
        pcall(function()
          Prisel.Admin.OpenPlayerInfo(v)
        end)        
      end


      function panel:OnMousePressed()
        if self.Expand then
          self.Expand = false
          self:SizeTo(self:GetWide(), self:GetTall() - DarkRP.ScrH * 0.13, 0.2, 0, -1, function() end)
        else
          self.Expand = true
          self:SizeTo(self:GetWide(), self:GetTall() + DarkRP.ScrH * 0.13, 0.2, 0, -1, function() end)
        end
      end
    end
  end

  scoreboardFrame.OnRemove = function()
    iscrolled = vbar:GetScroll()
  end
end

hook.Add("ScoreboardShow", "PriselV3_Hook_ScoreboardShow", function()
  if not IsValid(scoreboardFrame) then
    Prisel.Scoreboard.Open()

    return true
  end
end)
  
hook.Add("ScoreboardHide", "PriselV3_Hook_ScoreboardHide", function()
  if IsValid(scoreboardFrame) then
    PriselHUD.ActiveLogo = true
    Prisel.Scoreboard.Close()
  end
end)