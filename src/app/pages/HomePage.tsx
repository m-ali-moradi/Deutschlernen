import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { Flame, Zap, Trophy, ChevronRight } from "lucide-react";
import { ProgressRing } from "../components/ProgressRing";
import { useAppState } from "../data/store";

const sections = [
  { path: "/grammar", label: "Grammar", subtitle: "Regeln & Struktur", icon: "📘", gradient: "from-purple-500 to-purple-700", shadowColor: "shadow-purple-200 dark:shadow-purple-900/40" },
  { path: "/vocabulary", label: "Vocabulary", subtitle: "Wörter & Business", icon: "📚", gradient: "from-blue-500 to-blue-700", shadowColor: "shadow-blue-200 dark:shadow-blue-900/40" },
  { path: "/exercises", label: "Exercises", subtitle: "Tests & Quiz", icon: "✏️", gradient: "from-orange-400 to-orange-600", shadowColor: "shadow-orange-200 dark:shadow-orange-900/40" },
];

export function HomePage() {
  const navigate = useNavigate();
  const { userStats } = useAppState();

  return (
    <div className="px-5 pt-6 pb-4 space-y-6">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="flex items-center justify-between"
      >
        <div>
          <h1 className="text-[28px] text-gray-900 dark:text-white">Lerne Deutsch 🇩🇪</h1>
          <p className="text-gray-500 dark:text-gray-400 mt-0.5">Willkommen zurück!</p>
        </div>
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1 bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 px-3 py-1.5 rounded-full">
            <Flame size={16} />
            <span className="text-[13px]">{userStats.streak}</span>
          </div>
          <div className="flex items-center gap-1 bg-yellow-100 dark:bg-yellow-900/30 text-yellow-600 dark:text-yellow-400 px-3 py-1.5 rounded-full">
            <Zap size={16} />
            <span className="text-[13px]">{userStats.xp}</span>
          </div>
        </div>
      </motion.div>

      {/* Weekly Progress */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-lg shadow-gray-200/50 dark:shadow-black/20"
      >
        <div className="flex items-center gap-5">
          <ProgressRing progress={userStats.weeklyProgress} size={100} strokeWidth={8}>
            <div className="text-center">
              <span className="text-[22px] text-gray-900 dark:text-white">{userStats.weeklyProgress}%</span>
              <p className="text-[10px] text-gray-400">Woche</p>
            </div>
          </ProgressRing>
          <div className="flex-1 space-y-3">
            <h3 className="text-gray-900 dark:text-white">Wochenfortschritt</h3>
            <div className="grid grid-cols-2 gap-2">
              <div className="bg-blue-50 dark:bg-blue-900/20 rounded-xl px-3 py-2">
                <p className="text-[11px] text-blue-500">Wörter</p>
                <p className="text-[18px] text-blue-700 dark:text-blue-300">{userStats.wordsLearned}</p>
              </div>
              <div className="bg-green-50 dark:bg-green-900/20 rounded-xl px-3 py-2">
                <p className="text-[11px] text-green-500">Übungen</p>
                <p className="text-[18px] text-green-700 dark:text-green-300">{userStats.exercisesCompleted}</p>
              </div>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Daily Challenge */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
        className="bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 rounded-3xl p-5 text-white shadow-lg shadow-purple-200 dark:shadow-purple-900/30"
      >
        <div className="flex items-center justify-between">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <Trophy size={18} />
              <span className="text-[13px] opacity-90">Tägliche Herausforderung</span>
            </div>
            <h3 className="text-white text-[18px] mt-1">5 Business-Wörter lernen</h3>
            <p className="text-[13px] opacity-80 mt-1">+50 XP Belohnung</p>
          </div>
          <button
            onClick={() => navigate("/vocabulary")}
            className="bg-white/20 hover:bg-white/30 transition-colors backdrop-blur-sm rounded-2xl px-4 py-2 flex items-center gap-1"
          >
            <span className="text-[13px]">Start</span>
            <ChevronRight size={16} />
          </button>
        </div>
      </motion.div>

      {/* Section Cards */}
      <div className="space-y-4">
        <h2 className="text-gray-900 dark:text-white">Lernbereiche</h2>
        {sections.map((section, idx) => (
          <motion.button
            key={section.path}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.3 + idx * 0.1 }}
            whileTap={{ scale: 0.97 }}
            onClick={() => navigate(section.path)}
            className={`w-full bg-gradient-to-r ${section.gradient} rounded-[20px] p-5 flex items-center gap-4 shadow-lg ${section.shadowColor} text-left`}
          >
            <span className="text-[36px]">{section.icon}</span>
            <div className="flex-1">
              <h3 className="text-white text-[18px]">{section.label}</h3>
              <p className="text-white/80 text-[13px] mt-0.5">{section.subtitle}</p>
            </div>
            <ChevronRight size={24} className="text-white/60" />
          </motion.button>
        ))}
      </div>

      {/* Achievements Preview */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.6 }}
        className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-lg shadow-gray-200/50 dark:shadow-black/20"
      >
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-gray-900 dark:text-white">Erfolge</h3>
          <button onClick={() => navigate("/profile")} className="text-[13px] text-blue-500">Alle anzeigen</button>
        </div>
        <div className="flex items-center gap-3">
          {["🎯", "📚", "🔥", "💎"].map((icon, i) => (
            <div
              key={i}
              className={`w-14 h-14 rounded-2xl flex items-center justify-center text-[24px] ${
                i < 3 ? "bg-yellow-50 dark:bg-yellow-900/20" : "bg-gray-100 dark:bg-slate-800 opacity-40"
              }`}
            >
              {icon}
            </div>
          ))}
          <div className="flex-1 text-right">
            <p className="text-[22px] text-gray-900 dark:text-white">3/6</p>
            <p className="text-[11px] text-gray-400">freigeschaltet</p>
          </div>
        </div>
      </motion.div>

      {/* Level Badge */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.7 }}
        className="flex items-center justify-center gap-3 py-2"
      >
        <div className="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-4 py-2 rounded-full flex items-center gap-2">
          <span className="text-[13px] opacity-80">Aktuelles Level:</span>
          <span className="text-[15px]">{userStats.level}</span>
        </div>
      </motion.div>
    </div>
  );
}
