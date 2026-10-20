-- Auto Farm Bone Script
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Hàm dịch chuyển và nhặt xương
_G.AutoFarmBone = true

task.spawn(function()
    while task.wait(0.5) do
        if not _G.AutoFarmBone then break end
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Bone" or v.Name == "Bones" then -- Tên vật phẩm xương trong game
                    if v:IsA("BasePart") or v:IsA("Model") then
                        local targetPart = v:IsA("Model") and v.PrimaryPart or v
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            -- Dịch chuyển tới vị trí cục xương để lượm
                            character.HumanoidRootPart.CFrame = targetPart.CFrame
                            task.wait(0.2)
                        end
                    end
                end
            end
        end)
    end
end)
print("Đã kích hoạt Auto Farm Bone thành công!")
