import { createBrowserRouter } from "react-router";
import { Layout } from "./components/Layout";
import { HomePage } from "./pages/HomePage";
import { GrammarPage } from "./pages/GrammarPage";
import { GrammarDetailPage } from "./pages/GrammarDetailPage";
import { VocabularyPage } from "./pages/VocabularyPage";
import { ExercisePage } from "./pages/ExercisePage";
import { ProfilePage } from "./pages/ProfilePage";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Layout,
    children: [
      { index: true, Component: HomePage },
      { path: "grammar", Component: GrammarPage },
      { path: "grammar/:id", Component: GrammarDetailPage },
      { path: "vocabulary", Component: VocabularyPage },
      { path: "exercises", Component: ExercisePage },
      { path: "profile", Component: ProfilePage },
    ],
  },
]);
