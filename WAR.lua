local profile = {};
profile.Sets = {
    Idle = {
    },
    TP = {
    },
    Axe = {
    },
    Greataxe = {
    },
    Warcry = {
    },
    Sword = {
    },
    Greatsword = {
    },
    Polearm = {
    },
    H2H = {
    },
    Club = {
    },
    Berserk = {
    },
    BloodRage = {
    },
    Aggressor = {
    },
    Tomahawk = {
    },
    ProcSword = {
    },
    ProcDagger = {
    },
    ProcKatana = {
    },
    ProcScythe = {
    },
    ProcPole = {
    },
    ProcGreatKatana = {
    },
    ProcClub = {
    },
    ProcStaff = {
    },
    ProcGreatSword = {
    },
    Fastcast = {
    },
    WS = {
    },
    WSCrit = {
    },
    WSMulti = {
    },
    WSUpheaval = {
    },
    WSMacc = {
    },
    WSMab = {
    },
};

local wsMode = "Greataxe";

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if (args[1] == "wsmode") then
        if (args[2] == "s") then
            wsMode = "Sword";
            print("-- WSMode set to: Sword");
        elseif (args[2] == "gs") then
            wsMode = "Greatsword";
            print("-- WSMode set to: Greatsword");
        elseif (args[2] == "ga") then
            wsMode = "Greataxe";
            print("-- WSMode set to: Greataxe");
        elseif (args[2] == "c") then
            wsMode = "Club";
            print("-- WSMode set to: Club");
        elseif (args[2] == "h") then
            wsMode = "H2H";
            print("-- WSMode set to: H2H");
        elseif (args[2] == "p") then
            wsMode = "Polearm";
            print("-- WSMode set to: Polearm");
        elseif (args[2] == "a") then
            wsMode = "Axe";
            print("-- WSMode set to: Axe");
        elseif (args[2] == "pd") then
            wsMode = "ProcDagger";
            print("-- WSMode set to: Dagger (Proc)");
        elseif (args[2] == "psw") then
            wsMode = "ProcSword";
            print("-- WSMode set to: Sword (Proc)");
        elseif (args[2] == "pgs") then
            wsMode = "ProcGreatSword";
            print("-- WSMode set to: Great Sword (Proc)");
        elseif (args[2] == "psc") then
            wsMode = "ProcScythe";
            print("-- WSMode set to: Scythe (Proc)");
        elseif (args[2] == "pp") then
            wsMode = "ProcPole";
            print("-- WSMode set to: Polearm (Proc)");
        elseif (args[2] == "pk") then
            wsMode = "ProcKatana";
            print("-- WSMode set to: Katana (Proc)");
        elseif (args[2] == "pgk") then
            wsMode = "ProcGreatKatana";
            print("-- WSMode set to: Great Katana (Proc)");
        elseif (args[2] == "pc") then
            wsMode = "ProcClub";
            print("-- WSMode set to: Club (Proc)");
        elseif (args[2] == "pst") then
            wsMode = "ProcStaff";
            print("-- WSMode set to: Staff (Proc)");
        else
            print("Invalid WSMode");
        end
    end
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    -- Keep armor and weapons separate
    if (player.Status == "Engaged") then
        gFunc.EquipSet(profile.Sets.TP);
    else
        gFunc.EquipSet(profile.Sets.Idle);
    end

    gFunc.EquipSet(profile.Sets[wsMode]);
end

profile.HandleAbility = function()
    local act = gData.GetAction();
    if (act.Name == "Berserk") then
        gFunc.EquipSet(profile.Sets.Berserk);
    elseif (act.Name == "Warcry") then
        gFunc.EquipSet(profile.Sets.Warcry);
    elseif (act.Name == "Aggressor") then
        gFunc.EquipSet(profile.Sets.Aggressor);
    elseif (act.Name == "Blood Rage") then
        gFunc.EquipSet(profile.Sets.BloodRage);
    elseif (act.Name == "Tomahawk") then
        gFunc.EquipSet(profile.Sets.Tomahawk);
    end
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    gFunc.EquipSet(profile.Sets.Fastcast);
end

profile.HandleMidcast = function()
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    local act = gData.GetAction();
    if (wsMode:find("Proc")) then
        -- Avoid doing too much damage for Abyssea or Dynamis proc
        return;
    end

    if (act.Name == "Resolution") then
        gFunc.EquipSet(profile.Sets.WSMulti);
    elseif (act.Name == "Upheaval") then
        gFunc.EquipSet(profile.Sets.WSUpheaval)
    elseif (act.Name == "Ukko's Fury") then
        gFunc.EquipSet(profile.Sets.WSCrit);
    elseif (act.Name:find("Break")) then
        gFunc.EquipSet(profile.Sets.WSMacc);
    elseif (act.Name == "Burning Blade" or act.Name == "Red Lotus Blade" or act.Name == "Seraph Blade" or act.Name == "Cloudsplitter"
     or act.Name == "Earth Crusher" or act.Name == "Flash Nova" or act.Name == "Sanguine Blade") then
        gFunc.EquipSet(profile.Sets.WSMab);
    else
        gFunc.EquipSet(profile.Sets.WS);
    end
end

return profile;
