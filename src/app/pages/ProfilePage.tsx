import { useState } from "react";
import { useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowLeft, Moon, Sun, Globe, BookOpen, Zap, Flame, Target, Trophy, AlertTriangle, ChevronRight } from "lucide-react";
import { useAppState, achievementData } from "../data/store";
import { ProgressRing } from "../components/ProgressRing";

export function ProfilePage() {
  const navigate = useNavigate();
  const { userStats, darkMode, toggleDarkMode, nativeLanguage, setNativeLanguage } = useAppState();
  const [language, setLanguage] = useState("en");

  const statCards = [
    { label: "XP Punkte", value: userStats.xp, icon: <Zap size={18} className="text-yellow-500" />, bg: "bg-yellow-50 dark:bg-yellow-900/20" },
    { label: "Streak", value: `${userStats.streak} Tage`, icon: <Flame size={18} className="text-orange-500" />, bg: "bg-orange-50 dark:bg-orange-900/20" },
    { label: "Wörter", value: userStats.wordsLearned, icon: <BookOpen size={18} className="text-blue-500" />, bg: "bg-blue-50 dark:bg-blue-900/20" },
    { label: "Übungen", value: userStats.exercisesCompleted, icon: <Target size={18} className="text-green-500" />, bg: "bg-green-50 dark:bg-green-900/20" },
  ];

  return (
    <div className="px-5 pt-6 pb-4 space-y-5">
      {/* Header */}
      <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} className="flex items-center gap-3">
        <button onClick={() => navigate("/")} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
          <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
        </button>
        <div className="flex-1">
          <h1 className="text-[24px] text-gray-900 dark:text-white">Profil</h1>
          <p className="text-[13px] text-gray-500 dark:text-gray-400">Deine Lernstatistik</p>
        </div>
      </motion.div>

      {/* Level Card */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="bg-gradient-to-br from-blue-500 via-purple-500 to-pink-500 rounded-3xl p-6 text-center shadow-lg shadow-purple-200 dark:shadow-purple-900/30"
      >
        <div className="flex justify-center mb-3">
          <ProgressRing progress={userStats.weeklyProgress} size={110} strokeWidth={8} color="#ffffff">
            <div className="text-center">
              <span className="text-[28px] text-white">{userStats.level}</span>
              <p className="text-[10px] text-white/70">Level</p>
            </div>
          </ProgressRing>
        </div>
        <h2 className="text-white text-[20px]">Deutsch Lerner</h2>
        <p className="text-white/70 text-[13px] mt-1">{userStats.weeklyProgress}% Wochenfortschritt</p>
        <div className="flex items-center justify-center gap-4 mt-4">
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl px-4 py-2">
            <p className="text-white/60 text-[10px]">XP</p>
            <p className="text-white text-[18px]">{userStats.xp}</p>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl px-4 py-2">
            <p className="text-white/60 text-[10px]">Streak</p>
            <p className="text-white text-[18px]">{userStats.streak} 🔥</p>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-2xl px-4 py-2">
            <p className="text-white/60 text-[10px]">Grammatik</p>
            <p className="text-white text-[18px]">{userStats.grammarTopicsCompleted}</p>
          </div>
        </div>
      </motion.div>

      {/* Stats Grid */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <h3 className="text-gray-900 dark:text-white mb-3">Statistiken</h3>
        <div className="grid grid-cols-2 gap-3">
          {statCards.map((stat, idx) => (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.25 + idx * 0.05 }}
              className={`${stat.bg} rounded-2xl p-4`}
            >
              <div className="flex items-center gap-2 mb-2">
                {stat.icon}
                <p className="text-[12px] text-gray-500 dark:text-gray-400">{stat.label}</p>
              </div>
              <p className="text-[22px] text-gray-900 dark:text-white">{stat.value}</p>
            </motion.div>
          ))}
        </div>
      </motion.div>

      {/* Weak Areas */}
      {userStats.weakAreas.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.35 }}
          className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-md shadow-gray-100 dark:shadow-black/10"
        >
          <div className="flex items-center gap-2 mb-3">
            <AlertTriangle size={18} className="text-amber-500" />
            <h3 className="text-gray-900 dark:text-white">Schwache Bereiche</h3>
          </div>
          <div className="space-y-2">
            {userStats.weakAreas.map(area => (
              <button
                key={area}
                onClick={() => navigate("/grammar")}
                className="w-full flex items-center justify-between bg-amber-50 dark:bg-amber-900/10 rounded-xl px-4 py-3"
              >
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-amber-100 dark:bg-amber-900/20 flex items-center justify-center">
                    <span className="text-[14px]">📘</span>
                  </div>
                  <span className="text-[14px] text-amber-800 dark:text-amber-200">{area}</span>
                </div>
                <ChevronRight size={16} className="text-amber-400" />
              </button>
            ))}
          </div>
        </motion.div>
      )}

      {/* Achievements */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
        className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-md shadow-gray-100 dark:shadow-black/10"
      >
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <Trophy size={18} className="text-yellow-500" />
            <h3 className="text-gray-900 dark:text-white">Erfolge</h3>
          </div>
          <span className="text-[12px] text-gray-400">{achievementData.filter(a => a.unlocked).length}/{achievementData.length}</span>
        </div>
        <div className="space-y-2.5">
          {achievementData.map((achievement, idx) => (
            <motion.div
              key={achievement.id}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.45 + idx * 0.04 }}
              className={`flex items-center gap-3 p-3 rounded-2xl ${
                achievement.unlocked
                  ? "bg-yellow-50 dark:bg-yellow-900/10"
                  : "bg-gray-50 dark:bg-slate-800 opacity-50"
              }`}
            >
              <div className={`w-11 h-11 rounded-2xl flex items-center justify-center text-[22px] ${
                achievement.unlocked
                  ? "bg-gradient-to-br from-yellow-300 to-amber-400 shadow-sm"
                  : "bg-gray-200 dark:bg-slate-700"
              }`}>
                {achievement.icon}
              </div>
              <div className="flex-1">
                <p className="text-[14px] text-gray-900 dark:text-white">{achievement.title}</p>
                <p className="text-[11px] text-gray-500 dark:text-gray-400">{achievement.description}</p>
              </div>
              {achievement.unlocked && (
                <span className="text-[10px] bg-green-100 dark:bg-green-900/20 text-green-600 dark:text-green-400 px-2 py-0.5 rounded-full">Fertig</span>
              )}
            </motion.div>
          ))}
        </div>
      </motion.div>

      {/* Settings */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
        className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-md shadow-gray-100 dark:shadow-black/10"
      >
        <h3 className="text-gray-900 dark:text-white mb-3">Einstellungen</h3>
        <div className="space-y-1">
          {/* Dark Mode Toggle */}
          <button
            onClick={toggleDarkMode}
            className="w-full flex items-center justify-between py-3 px-1"
          >
            <div className="flex items-center gap-3">
              {darkMode ? <Moon size={20} className="text-indigo-400" /> : <Sun size={20} className="text-amber-500" />}
              <span className="text-[14px] text-gray-700 dark:text-gray-300">
                {darkMode ? "Dark Mode" : "Light Mode"}
              </span>
            </div>
            <div className={`w-12 h-7 rounded-full p-0.5 transition-colors ${darkMode ? "bg-indigo-500" : "bg-gray-300"}`}>
              <motion.div
                className="w-6 h-6 bg-white rounded-full shadow-sm"
                animate={{ x: darkMode ? 20 : 0 }}
                transition={{ type: "spring", stiffness: 500, damping: 30 }}
              />
            </div>
          </button>

          <div className="border-t border-gray-100 dark:border-slate-800" />

          {/* Language Setting */}
          <div className="flex items-center justify-between py-3 px-1">
            <div className="flex items-center gap-3">
              <Globe size={20} className="text-blue-500" />
              <span className="text-[14px] text-gray-700 dark:text-gray-300">Sprache</span>
            </div>
            <select
              value={language}
              onChange={e => setLanguage(e.target.value)}
              className="bg-gray-100 dark:bg-slate-800 text-gray-700 dark:text-gray-300 rounded-xl px-3 py-1.5 text-[13px] border-0"
            >
              <option value="en">English</option>
              <option value="de">Deutsch</option>
              <option value="tr">Türkçe</option>
              <option value="ar">العربية</option>
            </select>
          </div>

          <div className="border-t border-gray-100 dark:border-slate-800" />

          {/* Native Language Setting */}
          <div className="flex items-center justify-between py-3 px-1">
            <div className="flex items-center gap-3">
              <Globe size={20} className="text-purple-500" />
              <span className="text-[14px] text-gray-700 dark:text-gray-300">Muttersprache</span>
            </div>
            <select
              value={nativeLanguage}
              onChange={e => setNativeLanguage(e.target.value as "en" | "dari")}
              className="bg-gray-100 dark:bg-slate-800 text-gray-700 dark:text-gray-300 rounded-xl px-3 py-1.5 text-[13px] border-0"
            >
              <option value="en">English</option>
              <option value="dari">دری (Dari)</option>
            </select>
          </div>
        </div>
      </motion.div>

      {/* App Version */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.6 }}
        className="text-center py-3"
      >
        <p className="text-[12px] text-gray-400">Deutsch Lernen App v1.0</p>
        <p className="text-[11px] text-gray-300 dark:text-gray-600 mt-0.5">Made with ❤️ for German learners</p>
      </motion.div>
    </div>
  );
}