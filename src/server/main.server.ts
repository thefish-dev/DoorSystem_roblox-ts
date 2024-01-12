/* eslint-disable prettier/prettier */
import { KnitServer as Knit } from "@rbxts/knit";

const services = script.Parent?.FindFirstChild("Services")?.GetChildren();
if (services) {
    for (const service of services) {
        if (service.IsA("ModuleScript")) require(service);
    }
}

Knit.Start().andThen().catch(warn);