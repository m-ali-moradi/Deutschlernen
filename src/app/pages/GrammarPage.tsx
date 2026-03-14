import { useState } from "react";
import { useNavigate } from "react-router";
import { motion, AnimatePresence } from "motion/react";
import { ArrowLeft, ChevronRight, Filter } from "lucide-react";
import { grammarData } from "../data/store";

const levels = ["Alle", "A1", "A2", "B1", "B2"];
const categories = ["Alle", "Artikel", "Zeiten", "Nebensätze", "Präpositionen", "Konjunktiv"];

const categoryColors: Record<string, string> = {
  Artikel: "from-blue-400 to-blue-600",
  Zeiten: "from-amber-400 to-amber-600",
  Nebensätze: "from-teal-400 to-teal-600",
  Präpositionen: "from-pink-400 to-pink-600",
  Konjunktiv: "from-violet-400 to-violet-600",
};

export function GrammarPage() {
  const navigate = useNavigate();
  const [selectedLevel, setSelectedLevel] = useState("Alle");
  const [selectedCategory, setSelectedCategory] = useState("Alle");
  const [showFilters, setShowFilters] = useState(false);

  const filtered = grammarData.filter(t => {
    if (selectedLevel !== "Alle" && t.level !== selectedLevel) return false;
    if (selectedCategory !== "Alle" && t.category !== selectedCategory) return false;
    return true;
  });

  return (
    <div className="px-5 pt-6 pb-4 space-y-5">
      {/* Header */}
      <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} className="flex items-center gap-3">
        <button onClick={() => navigate("/")} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
          <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
        </button>
        <div className="flex-1">
          <h1 className="text-[24px] text-gray-900 dark:text-white">Grammatik 📘</h1>
          <p className="text-[13px] text-gray-500 dark:text-gray-400">Regeln & Struktur</p>
        </div>
        <button
          onClick={() => setShowFilters(!showFilters)}
          className={`p-2 rounded-xl shadow-sm transition-colors ${showFilters ? "bg-blue-500 text-white" : "bg-white dark:bg-slate-800 text-gray-600 dark:text-gray-300"}`}
        >
          <Filter size={20} />
        </button>
      </motion.div>

      {/* Level Filter */}
      <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.1 }} className="flex gap-2 overflow-x-auto pb-1 no-scrollbar">
        {levels.map(level => (
          <button
            key={level}
            onClick={() => setSelectedLevel(level)}
            className={`px-4 py-2 rounded-full text-[13px] whitespace-nowrap transition-all ${
              selectedLevel === level
                ? "bg-gradient-to-r from-blue-500 to-purple-500 text-white shadow-md shadow-blue-200 dark:shadow-blue-900/30"
                : "bg-white dark:bg-slate-800 text-gray-600 dark:text-gray-300 shadow-sm"
            }`}
          >
            {level}
          </button>
        ))}
      </motion.div>

      {/* Category Filter */}
      <AnimatePresence>
        {showFilters && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="overflow-hidden"
          >
            <div className="flex flex-wrap gap-2 pb-2">
              {categories.map(cat => (
                <button
                  key={cat}
                  onClick={() => setSelectedCategory(cat)}
                  className={`px-3 py-1.5 rounded-full text-[12px] transition-all ${
                    selectedCategory === cat
                      ? "bg-purple-500 text-white"
                      : "bg-gray-100 dark:bg-slate-800 text-gray-600 dark:text-gray-300"
                  }`}
                >
                  {cat}
                </button>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Grammar Cards */}
      <div className="space-y-3">
        {filtered.map((topic, idx) => (
          <motion.button
            key={topic.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: idx * 0.05 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => navigate(`/grammar/${topic.id}`)}
            className="w-full bg-white dark:bg-slate-900 rounded-[20px] p-4 shadow-md shadow-gray-100 dark:shadow-black/10 flex items-center gap-4 text-left"
          >
            <div className={`w-12 h-12 rounded-2xl bg-gradient-to-br ${categoryColors[topic.category] || "from-gray-400 to-gray-600"} flex items-center justify-center text-[24px] shadow-sm`}>
              {topic.icon}
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2">
                <h3 className="text-gray-900 dark:text-white text-[15px] truncate">{topic.title}</h3>
                <span className="text-[10px] bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 px-2 py-0.5 rounded-full">{topic.level}</span>
              </div>
              <p className="text-[12px] text-gray-500 dark:text-gray-400 mt-0.5">{topic.category}</p>
              <div className="mt-2 w-full bg-gray-100 dark:bg-slate-700 rounded-full h-1.5">
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: `${topic.progress}%` }}
                  transition={{ duration: 0.8, delay: 0.3 + idx * 0.05 }}
                  className={`h-full rounded-full bg-gradient-to-r ${categoryColors[topic.category] || "from-gray-400 to-gray-600"}`}
                />
              </div>
            </div>
            <ChevronRight size={18} className="text-gray-300 dark:text-gray-600 shrink-0" />
          </motion.button>
        ))}
      </div>

      {filtered.length === 0 && (
        <div className="text-center py-12">
          <p className="text-[40px]">🔍</p>
          <p className="text-gray-400 mt-2">Keine Themen gefunden</p>
        </div>
      )}
    </div>
  );
}
