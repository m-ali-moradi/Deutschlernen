import { Outlet } from "react-router";
import { BottomNav } from "./BottomNav";

export function Layout() {
  return (
    <div className="min-h-screen bg-[#F5F7FA] dark:bg-slate-950 transition-colors duration-300">
      <div className="mx-auto max-w-lg min-h-screen pb-20">
        <Outlet />
      </div>
      <BottomNav />
    </div>
  );
}
