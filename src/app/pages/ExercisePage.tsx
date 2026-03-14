import { useState, useCallback } from "react";
import { useNavigate } from "react-router";
import { motion, AnimatePresence } from "motion/react";
import { ArrowLeft, RotateCcw, ChevronRight, Zap, Target, AlertTriangle } from "lucide-react";
import confetti from "canvas-confetti";
import { exerciseData, type Exercise } from "../data/store";
import { useAppState } from "../data/store";
import { ProgressRing } from "../components/ProgressRing";

type ExerciseState = "select" | "playing" | "feedback" | "results";

const exerciseTypes = [
  { type: "all", label: "Alle Übungen", icon: "📝", gradient: "from-blue-500 to-purple-600", count: exerciseData.length },
  { type: "multiple-choice", label: "Multiple Choice", icon: "🔘", gradient: "from-indigo-400 to-indigo-600", count: exerciseData.filter(e => e.type === "multiple-choice").length },
  { type: "fill-blank", label: "Lückentext", icon: "✍️", gradient: "from-teal-400 to-teal-600", count: exerciseData.filter(e => e.type === "fill-blank").length },
  { type: "sentence-order", label: "Satzordnung", icon: "🔀", gradient: "from-amber-400 to-amber-600", count: exerciseData.filter(e => e.type === "sentence-order").length },
  { type: "business-dialog", label: "Business Dialog", icon: "💼", gradient: "from-rose-400 to-rose-600", count: exerciseData.filter(e => e.type === "business-dialog").length },
];

const levelFilters = ["Alle", "A1", "A2", "B1", "B2"];

export function ExercisePage() {
  const navigate = useNavigate();
  const { addXP } = useAppState();
  const [state, setState] = useState<ExerciseState>("select");
  const [selectedLevel, setSelectedLevel] = useState("Alle");
  const [exercises, setExercises] = useState<Exercise[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);
  const [score, setScore] = useState(0);
  const [answers, setAnswers] = useState<boolean[]>([]);
  const [shakeWrong, setShakeWrong] = useState(false);

  const startExercise = useCallback((type: string) => {
    let filtered = exerciseData;
    if (type !== "all") {
      filtered = exerciseData.filter(e => e.type === type);
    }
    if (selectedLevel !== "Alle") {
      filtered = filtered.filter(e => e.level === selectedLevel);
    }
    if (filtered.length === 0) {
      filtered = exerciseData.slice(0, 5);
    }
    // Shuffle
    const shuffled = [...filtered].sort(() => Math.random() - 0.5);
    setExercises(shuffled);
    setCurrentIndex(0);
    setSelectedAnswer(null);
    setIsCorrect(null);
    setScore(0);
    setAnswers([]);
    setState("playing");
  }, [selectedLevel]);

  const handleAnswer = useCallback((answerIndex: number) => {
    if (selectedAnswer !== null) return;
    const exercise = exercises[currentIndex];
    const correct = answerIndex === exercise.correctAnswer;
    setSelectedAnswer(answerIndex);
    setIsCorrect(correct);
    if (correct) {
      setScore(prev => prev + 1);
    } else {
      setShakeWrong(true);
      setTimeout(() => setShakeWrong(false), 500);
    }
    setAnswers(prev => [...prev, correct]);
    setState("feedback");
  }, [selectedAnswer, exercises, currentIndex]);

  const nextQuestion = useCallback(() => {
    if (currentIndex + 1 >= exercises.length) {
      setState("results");
      addXP(score * 10);
      const percentage = Math.round((score / exercises.length) * 100);
      if (percentage === 100) {
        setTimeout(() => {
          confetti({
            particleCount: 150,
            spread: 100,
            origin: { y: 0.6 },
            colors: ["#6366f1", "#a855f7", "#ec4899", "#f59e0b", "#10b981"],
          });
        }, 500);
      }
    } else {
      setCurrentIndex(prev => prev + 1);
      setSelectedAnswer(null);
      setIsCorrect(null);
      setState("playing");
    }
  }, [currentIndex, exercises.length, score, addXP]);

  const getTypeLabel = (type: string) => {
    switch (type) {
      case "multiple-choice": return "Multiple Choice";
      case "fill-blank": return "Lückentext";
      case "sentence-order": return "Satzordnung";
      case "business-dialog": return "Business Dialog";
      case "listening": return "Hören";
      default: return type;
    }
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case "multiple-choice": return "🔘";
      case "fill-blank": return "✍️";
      case "sentence-order": return "🔀";
      case "business-dialog": return "💼";
      case "listening": return "🎧";
      default: return "📝";
    }
  };

  // Select Screen
  if (state === "select") {
    return (
      <div className="px-5 pt-6 pb-4 space-y-5">
        <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} className="flex items-center gap-3">
          <button onClick={() => navigate("/")} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
            <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
          </button>
          <div className="flex-1">
            <h1 className="text-[24px] text-gray-900 dark:text-white">Übungen ✏️</h1>
            <p className="text-[13px] text-gray-500 dark:text-gray-400">Tests & Quiz</p>
          </div>
        </motion.div>

        {/* Level Filter */}
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.1 }} className="flex gap-2 overflow-x-auto pb-1 no-scrollbar">
          {levelFilters.map(level => (
            <button
              key={level}
              onClick={() => setSelectedLevel(level)}
              className={`px-4 py-2 rounded-full text-[13px] whitespace-nowrap transition-all ${
                selectedLevel === level
                  ? "bg-gradient-to-r from-orange-400 to-orange-600 text-white shadow-md shadow-orange-200 dark:shadow-orange-900/30"
                  : "bg-white dark:bg-slate-800 text-gray-600 dark:text-gray-300 shadow-sm"
              }`}
            >
              {level}
            </button>
          ))}
        </motion.div>

        {/* Exercise Type Cards */}
        <div className="space-y-3">
          <h3 className="text-gray-900 dark:text-white">Übungstypen</h3>
          {exerciseTypes.map((et, idx) => (
            <motion.button
              key={et.type}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.15 + idx * 0.06 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => { startExercise(et.type); }}
              className={`w-full bg-gradient-to-r ${et.gradient} rounded-[20px] p-5 flex items-center gap-4 shadow-lg text-left`}
            >
              <span className="text-[32px]">{et.icon}</span>
              <div className="flex-1">
                <h3 className="text-white text-[16px]">{et.label}</h3>
                <p className="text-white/70 text-[12px] mt-0.5">{et.count} Fragen</p>
              </div>
              <ChevronRight size={22} className="text-white/60" />
            </motion.button>
          ))}
        </div>

        {/* Quick Stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-md shadow-gray-100 dark:shadow-black/10"
        >
          <h3 className="text-gray-900 dark:text-white mb-3">Tipps</h3>
          <div className="space-y-2">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-xl bg-blue-100 dark:bg-blue-900/20 flex items-center justify-center">
                <Target size={16} className="text-blue-500" />
              </div>
              <p className="text-[13px] text-gray-600 dark:text-gray-400">Lies die Frage sorgfältig durch</p>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-xl bg-green-100 dark:bg-green-900/20 flex items-center justify-center">
                <Zap size={16} className="text-green-500" />
              </div>
              <p className="text-[13px] text-gray-600 dark:text-gray-400">Jede richtige Antwort = +10 XP</p>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-xl bg-amber-100 dark:bg-amber-900/20 flex items-center justify-center">
                <AlertTriangle size={16} className="text-amber-500" />
              </div>
              <p className="text-[13px] text-gray-600 dark:text-gray-400">100% Score = Konfetti-Belohnung!</p>
            </div>
          </div>
        </motion.div>
      </div>
    );
  }

  // Playing / Feedback Screen
  if (state === "playing" || state === "feedback") {
    const exercise = exercises[currentIndex];
    const progress = ((currentIndex + 1) / exercises.length) * 100;

    return (
      <div className="px-5 pt-6 pb-4 min-h-screen flex flex-col">
        {/* Top Bar */}
        <div className="flex items-center gap-3 mb-4">
          <button onClick={() => setState("select")} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
            <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
          </button>
          <div className="flex-1">
            <div className="w-full bg-gray-200 dark:bg-slate-700 rounded-full h-2.5">
              <motion.div
                animate={{ width: `${progress}%` }}
                className="h-full rounded-full bg-gradient-to-r from-orange-400 to-orange-600"
                transition={{ duration: 0.3 }}
              />
            </div>
          </div>
          <span className="text-[13px] text-gray-500 dark:text-gray-400 min-w-[40px] text-right">{currentIndex + 1}/{exercises.length}</span>
        </div>

        {/* Type Badge */}
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex items-center gap-2 mb-6">
          <span className="text-[18px]">{getTypeIcon(exercise.type)}</span>
          <span className="text-[12px] text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-slate-800 px-3 py-1 rounded-full">{getTypeLabel(exercise.type)}</span>
          <span className="text-[11px] text-blue-500 bg-blue-100 dark:bg-blue-900/30 px-2 py-0.5 rounded-full">{exercise.level}</span>
        </motion.div>

        {/* Question Card */}
        <motion.div
          key={exercise.id}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-white dark:bg-slate-900 rounded-3xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-black/20 mb-6"
        >
          <h2 className="text-gray-900 dark:text-white text-[18px] text-center leading-relaxed">{exercise.question}</h2>
        </motion.div>

        {/* Answer Options */}
        <div className="space-y-3 flex-1">
          {exercise.options.map((option, idx) => {
            let bgClass = "bg-white dark:bg-slate-800 border-2 border-gray-100 dark:border-slate-700";
            let textClass = "text-gray-700 dark:text-gray-200";

            if (selectedAnswer !== null) {
              if (idx === exercise.correctAnswer) {
                bgClass = "bg-green-50 dark:bg-green-900/20 border-2 border-green-400 dark:border-green-500";
                textClass = "text-green-700 dark:text-green-300";
              } else if (idx === selectedAnswer && !isCorrect) {
                bgClass = "bg-red-50 dark:bg-red-900/20 border-2 border-red-400 dark:border-red-500";
                textClass = "text-red-700 dark:text-red-300";
              }
            }

            return (
              <motion.button
                key={idx}
                initial={{ opacity: 0, x: -10 }}
                animate={{
                  opacity: 1,
                  x: shakeWrong && idx === selectedAnswer && !isCorrect ? [0, -8, 8, -8, 8, 0] : 0,
                }}
                transition={{
                  opacity: { delay: idx * 0.05 },
                  x: { duration: 0.4 },
                }}
                whileTap={selectedAnswer === null ? { scale: 0.97 } : undefined}
                onClick={() => handleAnswer(idx)}
                disabled={selectedAnswer !== null}
                className={`w-full ${bgClass} rounded-2xl p-4 text-left flex items-center gap-3 transition-all`}
              >
                <div className={`w-8 h-8 rounded-full flex items-center justify-center text-[13px] ${
                  selectedAnswer !== null && idx === exercise.correctAnswer
                    ? "bg-green-400 text-white"
                    : selectedAnswer === idx && !isCorrect
                    ? "bg-red-400 text-white"
                    : "bg-gray-100 dark:bg-slate-700 text-gray-500 dark:text-gray-400"
                }`}>
                  {selectedAnswer !== null && idx === exercise.correctAnswer ? "✓" :
                   selectedAnswer === idx && !isCorrect ? "✗" :
                   String.fromCharCode(65 + idx)}
                </div>
                <span className={`text-[14px] ${textClass}`}>{option}</span>
              </motion.button>
            );
          })}
        </div>

        {/* Feedback & Next */}
        <AnimatePresence>
          {state === "feedback" && (
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 30 }}
              className="mt-4 mb-4"
            >
              <div className={`rounded-2xl p-4 mb-3 ${isCorrect
                ? "bg-green-100 dark:bg-green-900/20 border border-green-200 dark:border-green-800"
                : "bg-red-100 dark:bg-red-900/20 border border-red-200 dark:border-red-800"
              }`}>
                <div className="flex items-center gap-2">
                  <span className="text-[20px]">{isCorrect ? "🎉" : "💡"}</span>
                  <span className={`text-[14px] ${isCorrect ? "text-green-700 dark:text-green-300" : "text-red-700 dark:text-red-300"}`}>
                    {isCorrect ? "Richtig! Gut gemacht!" : `Die richtige Antwort ist: ${exercises[currentIndex].options[exercises[currentIndex].correctAnswer]}`}
                  </span>
                </div>
              </div>
              <button
                onClick={nextQuestion}
                className="w-full bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-2xl py-4 shadow-lg shadow-blue-200 dark:shadow-blue-900/30 flex items-center justify-center gap-2 active:scale-[0.98] transition-transform"
              >
                <span className="text-[15px]">{currentIndex + 1 >= exercises.length ? "Ergebnis anzeigen" : "Nächste Frage"}</span>
                <ChevronRight size={18} />
              </button>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    );
  }

  // Results Screen
  if (state === "results") {
    const percentage = Math.round((score / exercises.length) * 100);
    const wrongCount = exercises.length - score;
    const wrongTopics = exercises
      .filter((_, i) => !answers[i])
      .map(e => e.topic);
    const uniqueWeakTopics = [...new Set(wrongTopics)];

    return (
      <div className="px-5 pt-6 pb-4 min-h-screen flex flex-col items-center">
        <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} className="w-full flex items-center gap-3 mb-8">
          <button onClick={() => setState("select")} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
            <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
          </button>
          <h1 className="text-[22px] text-gray-900 dark:text-white flex-1">Ergebnis</h1>
        </motion.div>

        {/* Score Circle */}
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{ type: "spring", stiffness: 200, damping: 15, delay: 0.2 }}
        >
          <ProgressRing
            progress={percentage}
            size={180}
            strokeWidth={12}
            color={percentage >= 80 ? "url(#gradient-success)" : percentage >= 50 ? "url(#gradient-warning)" : "url(#gradient-error)"}
          >
            <svg width={0} height={0}>
              <defs>
                <linearGradient id="gradient-success" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#10b981" />
                  <stop offset="100%" stopColor="#059669" />
                </linearGradient>
                <linearGradient id="gradient-warning" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#f59e0b" />
                  <stop offset="100%" stopColor="#d97706" />
                </linearGradient>
                <linearGradient id="gradient-error" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#ef4444" />
                  <stop offset="100%" stopColor="#dc2626" />
                </linearGradient>
              </defs>
            </svg>
            <div className="text-center">
              <motion.span
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.8 }}
                className="text-[36px] text-gray-900 dark:text-white"
              >{percentage}%</motion.span>
              <p className="text-[12px] text-gray-400">Ergebnis</p>
            </div>
          </ProgressRing>
        </motion.div>

        {/* Emoji & Message */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="text-center mt-4 mb-6"
        >
          <p className="text-[36px]">
            {percentage === 100 ? "🏆" : percentage >= 80 ? "🎉" : percentage >= 50 ? "👍" : "💪"}
          </p>
          <p className="text-[16px] text-gray-700 dark:text-gray-300 mt-1">
            {percentage === 100 ? "Perfekt! Unglaublich!" : percentage >= 80 ? "Sehr gut gemacht!" : percentage >= 50 ? "Gut! Weiter üben!" : "Nicht aufgeben!"}
          </p>
        </motion.div>

        {/* Stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="w-full grid grid-cols-3 gap-3 mb-5"
        >
          <div className="bg-green-50 dark:bg-green-900/20 rounded-2xl p-4 text-center">
            <p className="text-[24px] text-green-600 dark:text-green-400">{score}</p>
            <p className="text-[11px] text-green-500 mt-0.5">Richtig</p>
          </div>
          <div className="bg-red-50 dark:bg-red-900/20 rounded-2xl p-4 text-center">
            <p className="text-[24px] text-red-600 dark:text-red-400">{wrongCount}</p>
            <p className="text-[11px] text-red-500 mt-0.5">Falsch</p>
          </div>
          <div className="bg-blue-50 dark:bg-blue-900/20 rounded-2xl p-4 text-center">
            <p className="text-[24px] text-blue-600 dark:text-blue-400">+{score * 10}</p>
            <p className="text-[11px] text-blue-500 mt-0.5">XP</p>
          </div>
        </motion.div>

        {/* Weak Topics */}
        {uniqueWeakTopics.length > 0 && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.7 }}
            className="w-full bg-amber-50 dark:bg-amber-900/10 rounded-2xl p-4 mb-5 border border-amber-200 dark:border-amber-800/30"
          >
            <div className="flex items-center gap-2 mb-2">
              <AlertTriangle size={16} className="text-amber-500" />
              <p className="text-[13px] text-amber-700 dark:text-amber-300">Schwache Bereiche</p>
            </div>
            <div className="flex flex-wrap gap-2">
              {uniqueWeakTopics.map(topic => (
                <span key={topic} className="bg-amber-100 dark:bg-amber-900/20 text-amber-700 dark:text-amber-300 px-3 py-1 rounded-full text-[12px]">{topic}</span>
              ))}
            </div>
          </motion.div>
        )}

        {/* Actions */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8 }}
          className="w-full space-y-3 mt-auto"
        >
          <button
            onClick={() => { setState("select"); }}
            className="w-full bg-gradient-to-r from-orange-400 to-orange-600 text-white rounded-2xl py-4 shadow-lg shadow-orange-200 dark:shadow-orange-900/30 flex items-center justify-center gap-2 active:scale-[0.98] transition-transform"
          >
            <RotateCcw size={18} />
            <span className="text-[15px]">Nochmal versuchen</span>
          </button>
          <button
            onClick={() => navigate("/")}
            className="w-full bg-white dark:bg-slate-800 text-gray-700 dark:text-gray-300 rounded-2xl py-4 shadow-sm flex items-center justify-center gap-2 active:scale-[0.98] transition-transform"
          >
            <span className="text-[15px]">Zurück zum Home</span>
          </button>
        </motion.div>
      </div>
    );
  }

  return null;
}