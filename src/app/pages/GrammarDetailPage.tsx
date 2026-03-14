import { useParams, useNavigate } from "react-router";
import { motion } from "motion/react";
import { ArrowLeft, Lightbulb, BookOpen } from "lucide-react";
import { grammarData } from "../data/store";

export function GrammarDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const topic = grammarData.find(t => t.id === id);

  if (!topic) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p className="text-gray-400">Thema nicht gefunden</p>
      </div>
    );
  }

  return (
    <div className="px-5 pt-6 pb-4 space-y-5">
      {/* Header */}
      <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} className="flex items-center gap-3">
        <button onClick={() => navigate("/grammar")} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
          <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
        </button>
        <div className="flex-1">
          <h1 className="text-[22px] text-gray-900 dark:text-white">{topic.title}</h1>
          <div className="flex items-center gap-2 mt-0.5">
            <span className="text-[11px] bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 px-2 py-0.5 rounded-full">{topic.level}</span>
            <span className="text-[12px] text-gray-400">{topic.category}</span>
          </div>
        </div>
        <span className="text-[36px]">{topic.icon}</span>
      </motion.div>

      {/* Explanation */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-md shadow-gray-100 dark:shadow-black/10"
      >
        <div className="flex items-center gap-2 mb-3">
          <BookOpen size={18} className="text-blue-500" />
          <h3 className="text-gray-900 dark:text-white">Erklärung</h3>
        </div>
        <p className="text-[14px] text-gray-600 dark:text-gray-300 leading-relaxed">{topic.explanation}</p>
      </motion.div>

      {/* Rule Box */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
        className="bg-gradient-to-br from-indigo-500 to-purple-600 rounded-3xl p-5 shadow-lg shadow-purple-200 dark:shadow-purple-900/30"
      >
        <div className="flex items-center gap-2 mb-3">
          <Lightbulb size={18} className="text-yellow-300" />
          <h3 className="text-white text-[15px]">Regel</h3>
        </div>
        <p className="text-white/95 text-[15px] leading-relaxed">{topic.rule}</p>
      </motion.div>

      {/* Examples */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <h3 className="text-gray-900 dark:text-white mb-3">Beispiele</h3>
        <div className="space-y-2.5">
          {topic.examples.map((ex, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4 + idx * 0.08 }}
              className="bg-white dark:bg-slate-900 rounded-2xl p-4 shadow-sm flex items-start gap-3"
            >
              <div className="w-7 h-7 rounded-full bg-gradient-to-br from-blue-400 to-purple-500 flex items-center justify-center shrink-0 text-white text-[12px] shadow-sm">
                {idx + 1}
              </div>
              <p className="text-[14px] text-gray-700 dark:text-gray-200 leading-relaxed">{ex}</p>
            </motion.div>
          ))}
        </div>
      </motion.div>

      {/* Progress */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
        className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-sm"
      >
        <div className="flex items-center justify-between mb-2">
          <span className="text-[13px] text-gray-500 dark:text-gray-400">Fortschritt</span>
          <span className="text-[13px] text-purple-600 dark:text-purple-400">{topic.progress}%</span>
        </div>
        <div className="w-full bg-gray-100 dark:bg-slate-700 rounded-full h-2.5">
          <motion.div
            initial={{ width: 0 }}
            animate={{ width: `${topic.progress}%` }}
            transition={{ duration: 1, ease: "easeOut" }}
            className="h-full rounded-full bg-gradient-to-r from-blue-500 to-purple-500"
          />
        </div>
      </motion.div>

      {/* Try Exercise Button */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.6 }}
      >
        <button
          onClick={() => navigate("/exercises")}
          className="w-full bg-gradient-to-r from-orange-400 to-orange-600 text-white rounded-2xl py-4 shadow-lg shadow-orange-200 dark:shadow-orange-900/30 flex items-center justify-center gap-2 active:scale-[0.98] transition-transform"
        >
          <span className="text-[16px]">Übung starten</span>
          <span>✏️</span>
        </button>
      </motion.div>
    </div>
  );
}
