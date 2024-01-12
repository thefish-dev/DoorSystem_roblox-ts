/* eslint-disable prettier/prettier */
import { Workspace } from "@rbxts/services";
import { KnitClient as Knit } from "@rbxts/knit";

Knit.Start().andThen().catch(warn).await();

const PointsService = Knit.GetService("PointsService");

function PointsChanged(points: number) {
	print("My points:", points);
}

// Get points and listen for changes:
const initialPoints = PointsService.GetPoints();
PointsChanged(initialPoints);
PointsService.PointsChanged.Connect(PointsChanged);

// Ask server to give points randomly:
PointsService.GiveMePoints.Fire();
const givingPoints = task.spawn(() => {
    const enabled: Boolean = true;
    while (enabled) {
        PointsService.GiveMePoints.Fire();
        task.wait(5)
    }
})
task.delay(30, () => {task.cancel(givingPoints)});

// Grab MostPoints value:
let mostPoints = PointsService.MostPoints.Get();

// Keep MostPoints value updated:
PointsService.MostPoints.Changed.Connect(newMostPoints => {
	mostPoints = newMostPoints;
});

// Advanced example, using promises to get points:
PointsService.GetPointsPromise().then(points => {
	print("Got points:", points);
});