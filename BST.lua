local profile = {};
profile.Sets = {
    Idle = {
    },
    IdlePetDT = {
    },
    TP = {
    },
    Sword = {
    },
    SwordDual = {
    },
    AxeDual = {
    },
    Axe = {
    },
    Axe2 = {
    },
    Axe2Dual = {
    },
    Ready = {
    },
    PetAtk = {
    },
    PetMab = {
    },
    PetMacc = {
    },
    WS = {
    },
    WSMulti = {
    },
    WSMab = {
    },
    Reward = {
    },
    CallBeast = {
    },
};


profile.Packer = {
};

local PetPhys = T{ 'Somersault', 'Sensilla Blades', 'Tegmina Buffet', 'Cyclotail', 'Fluid Toss', 'Fluid Spread', 'Razor Fang', 'Claw Cyclone', 'Crossthrash', 'Tail Blow', 'Blockhead', 'Brain Crush' };
local PetMab = T{ 'Cursed Sphere', 'Venom', 'Digest', 'Fireball' };
local PetMacc = T{ 'Purulent Ooze', 'Corrosive Ooze', 'Roar', 'Predatory Glare', 'Infrasonics' };
local wsMode = "Axe";
local petDT = false;
local currPet = "dragonfly";

local function HandlePetAction(type)
    if (type == "phys") then
        gFunc.EquipSet(profile.Sets.PetAtk);
    elseif (type == "mab") then
        gFunc.EquipSet(profile.Sets.PetMab);
    elseif (type == "macc") then
        gFunc.EquipSet(profile.Sets.PetMacc);
    end
end

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if (args[1] == "wsmode") then
        if (args[2] == "a") then
            wsMode = "Axe";
            print("WSMode set to: Axe (Physical TP)");
        elseif (args[2] == "a2") then
            wsMode = "Axe2";
            print("WSMode set to: Axe2 (Multi-hit)");
        elseif (args[2] == "s") then
            wsMode = "Sword";
            print("WSMode set to: Sword");
        else
            print("Invalid WSMode");
        end
    elseif (args[1] == "petdt") then
        petDT = not petDT;
        print("Pet DT active: " .. tostring(petDT));
    elseif (args[1] == "pet") then
        if (args[2] == "") then
            print("Current pet: " .. currPet);
        else
            local petArg = args[2]:lower();
            if (petArg =="cricket" or petArg =="dragonfly" or petArg =="slime" or petArg =="slug" or petArg =="tiger" or petArg =="eft" or petArg =="lizard") then
                currPet = args[2];
                print("Set pet to " .. currPet);
            else
                print("Invalid pet");
            end
        end
    end
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    local pet = gData.GetPet();
    local petAction = gData.GetPetAction();
    
    if (petAction ~= nil and petAction.Name ~= "") then
        petAction.Name = string.sub(petAction.Name, 1, #petAction.Name - 1);
        if (PetPhys:contains(petAction.Name)) then
            HandlePetAction("phys");
            return;
        elseif (PetMab:contains(petAction.Name)) then
            HandlePetAction("mab");
            return;
        elseif (PetMacc:contains(petAction.Name)) then
            HandlePetAction("macc");
            return;
        end
    end

    if (player.Status == "Engaged") then
        gFunc.EquipSet(profile.Sets.TP);
    else
        if (pet ~= nil and petDT) then
            gFunc.EquipSet(profile.Sets.IdlePetDT);
        else
            gFunc.EquipSet(profile.Sets.Idle);
        end
    end
    if ((player.SubJob == "NIN" and (player.SubJobLevel >= 10 and player.SubJobSync >= 10)) or 
    (player.SubJob == "DNC" and (player.SubJobLevel >= 20 and player.SubJobSync >= 20))) then
        gFunc.EquipSet(profile.Sets[wsMode .. "Dual"]);
    else
        gFunc.EquipSet(profile.Sets[wsMode]);
    end
end

profile.HandleAbility = function()
    local act = gData.GetAction();

    if (act.Type == "Ready") then
        gFunc.EquipSet(profile.Sets.Ready);
    elseif (act.Name == "Reward") then
        gFunc.EquipSet(profile.Sets.Reward);
    elseif (act.Name == "Bestial Loyalty" or act.Name == "Call Beast") then
        gFunc.EquipSet(profile.Sets.CallBeast);

        if (currPet == "cricket") then
            gFunc.Equip("Ammo", "Spicy Broth");
        elseif (currPet == "dragonfly") then
            gFunc.Equip("Ammo", "Blackwater Broth");
        elseif (currPet == "slime") then
            gFunc.Equip("Ammo", "Decaying Broth");
        elseif (currPet == "slug") then
            gFunc.Equip("Ammo", "Dire Broth");
        elseif (currPet == "tiger") then
            gFunc.Equip("Ammo", "Blackwater Broth");
        elseif (currPet == "eft") then
            gFunc.Equip("Ammo", "Furious Broth");
        elseif (currPet == "lizard") then
            gFunc.Equip("Ammo", "Livid Broth");
        end
    end
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
end

profile.HandleMidcast = function()
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    local act = gData.GetAction();

    if (act.Name == "Decimation" or act.Name == "Ruinator") then
        gFunc.EquipSet(profile.Sets.WSMulti);
    elseif (act.Name == "Primal Rend" or act.Name == "Cloudsplitter") then
        gFunc.EquipSet(profile.Sets.WSMab);
    else
        gFunc.EquipSet(profile.Sets.WS);
    end    
end

return profile;
