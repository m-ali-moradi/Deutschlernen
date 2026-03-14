import { useState, useCallback } from "react";
import { useNavigate } from "react-router";
import { motion, AnimatePresence } from "motion/react";
import { ArrowLeft, Heart, Search, Plus, Volume2, X, ChevronRight, Languages } from "lucide-react";
import { useAppState, businessCategories, type VocabWord } from "../data/store";

type Tab = "words" | "phrases" | "favorites" | "difficult";

const phrases = [
  { id: "p1", german: "Sehr geehrte Damen und Herren", english: "Dear Sir or Madam", dari: "خانم‌ها و آقایان محترم", tag: "Formal" },
  { id: "p2", german: "Mit freundlichen Grüßen", english: "Kind regards", dari: "با احترام", tag: "Formal" },
  { id: "p3", german: "Könnten Sie mir bitte helfen?", english: "Could you please help me?", dari: "آیا می‌توانید لطفاً کمکم کنید؟", tag: "Polite" },
  { id: "p4", german: "Ich möchte mich vorstellen", english: "I would like to introduce myself", dari: "می‌خواهم خودم را معرفی کنم", tag: "Meeting" },
  { id: "p5", german: "Wie besprochen...", english: "As discussed...", dari: "طوری که بحث شد...", tag: "Email" },
  { id: "p6", german: "Im Anhang finden Sie...", english: "Please find attached...", dari: "در پیوست می‌یابید...", tag: "Email" },
  { id: "p7", german: "Ich bin für Rückfragen erreichbar", english: "I am available for further questions", dari: "من برای سوالات بیشتر در دسترس هستم", tag: "Email" },
  { id: "p8", german: "Vielen Dank für Ihre Nachricht", english: "Thank you for your message", dari: "تشکر از پیام شما", tag: "Email" },
  { id: "p9", german: "Ich würde gerne einen Termin vereinbaren", english: "I would like to schedule an appointment", dari: "می‌خواهم یک وقت ملاقات تعیین کنم", tag: "Meeting" },
  { id: "p10", german: "Darf ich kurz unterbrechen?", english: "May I briefly interrupt?", dari: "آیا می‌توانم کمی صحبت شما را قطع کنم؟", tag: "Meeting" },
  { id: "p11", german: "Was halten Sie davon?", english: "What do you think about it?", dari: "نظر شما چیست؟", tag: "Meeting" },
  { id: "p12", german: "Entschuldigung für die Verspätung", english: "Sorry for the delay", dari: "ببخشید بخاطر تأخیر", tag: "Polite" },
  { id: "p13", german: "Könnten wir das auf morgen verschieben?", english: "Could we postpone that to tomorrow?", dari: "آیا می‌توانیم این را به فردا موکول کنیم؟", tag: "Meeting" },
  { id: "p14", german: "Ich bin damit einverstanden", english: "I agree with that", dari: "من با این موافق هستم", tag: "Meeting" },
  { id: "p15", german: "Das ist eine gute Idee", english: "That is a good idea", dari: "این یک ایده خوب است", tag: "Polite" },
  { id: "p16", german: "Ich hätte eine Frage dazu", english: "I would have a question about that", dari: "من در این مورد یک سوال دارم", tag: "Meeting" },
  { id: "p17", german: "Bezugnehmend auf unser Gespräch...", english: "Referring to our conversation...", dari: "با اشاره به گفتگوی ما...", tag: "Email" },
  { id: "p18", german: "Ich freue mich auf die Zusammenarbeit", english: "I look forward to the collaboration", dari: "من مشتاق همکاری هستم", tag: "Formal" },
  { id: "p19", german: "Wann passt es Ihnen am besten?", english: "When suits you best?", dari: "چه وقت برای شما مناسب‌تر است؟", tag: "Polite" },
  { id: "p20", german: "Ich melde mich so schnell wie möglich", english: "I will get back to you as soon as possible", dari: "هر چه زودتر با شما تماس می‌گیرم", tag: "Email" },
];

export function VocabularyPage() {
  const navigate = useNavigate();
  const { vocabulary, toggleFavorite, setWordDifficulty, nativeLanguage, setNativeLanguage } = useAppState();
  const [tab, setTab] = useState<Tab>("words");
  const [search, setSearch] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [flashcardMode, setFlashcardMode] = useState(false);
  const [selectedWord, setSelectedWord] = useState<VocabWord | null>(null);
  const [flashcardIndex, setFlashcardIndex] = useState(0);
  const [isFlipped, setIsFlipped] = useState(false);

  const isDari = nativeLanguage === "dari";
  const getTranslation = (word: VocabWord) => isDari ? word.dari : word.english;
  const getContext = (word: VocabWord) => isDari ? word.contextDari : word.context;
  const langLabel = isDari ? "دری" : "English";

  const tabs: { key: Tab; label: string }[] = [
    { key: "words", label: "Wörter" },
    { key: "phrases", label: "Phrasen" },
    { key: "favorites", label: "Favoriten" },
    { key: "difficult", label: "Schwierig" },
  ];

  const filteredWords = vocabulary.filter(w => {
    if (tab === "favorites" && !w.isFavorite) return false;
    if (tab === "difficult" && !w.isDifficult) return false;
    if (selectedCategory && w.category !== selectedCategory) return false;
    if (search) {
      const s = search.toLowerCase();
      if (!w.german.toLowerCase().includes(s) && !w.english.toLowerCase().includes(s) && !w.dari.includes(s)) return false;
    }
    return true;
  });

  const flashcardWords = filteredWords.length > 0 ? filteredWords : vocabulary;

  const handleFlashcardNext = useCallback((difficulty: "easy" | "medium" | "hard") => {
    const word = flashcardWords[flashcardIndex];
    if (word) setWordDifficulty(word.id, difficulty);
    setIsFlipped(false);
    setTimeout(() => {
      setFlashcardIndex(prev => (prev + 1) % flashcardWords.length);
    }, 200);
  }, [flashcardIndex, flashcardWords, setWordDifficulty]);

  // Flashcard Mode
  if (flashcardMode) {
    const currentWord = flashcardWords[flashcardIndex];
    if (!currentWord) return null;
    const progress = ((flashcardIndex + 1) / flashcardWords.length) * 100;

    return (
      <div className="px-5 pt-6 pb-4 min-h-screen flex flex-col">
        <div className="flex items-center justify-between mb-6">
          <button onClick={() => { setFlashcardMode(false); setFlashcardIndex(0); setIsFlipped(false); }} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
            <X size={20} className="text-gray-600 dark:text-gray-300" />
          </button>
          <span className="text-[13px] text-gray-500 dark:text-gray-400">{flashcardIndex + 1} / {flashcardWords.length}</span>
        </div>

        {/* Progress Bar */}
        <div className="w-full bg-gray-200 dark:bg-slate-700 rounded-full h-2 mb-8">
          <motion.div
            animate={{ width: `${progress}%` }}
            className="h-full rounded-full bg-gradient-to-r from-blue-500 to-purple-500"
            transition={{ duration: 0.3 }}
          />
        </div>

        {/* Flashcard */}
        <div className="flex-1 flex items-center justify-center" style={{ perspective: 1000 }}>
          <motion.div
            className="w-full max-w-sm cursor-pointer"
            onClick={() => setIsFlipped(!isFlipped)}
            style={{ transformStyle: "preserve-3d" }}
            animate={{ rotateY: isFlipped ? 180 : 0 }}
            transition={{ duration: 0.3, ease: "easeInOut" }}
          >
            {/* Front */}
            <div
              className="bg-gradient-to-br from-blue-500 to-purple-600 rounded-3xl p-8 min-h-[280px] flex flex-col items-center justify-center shadow-2xl shadow-blue-200 dark:shadow-blue-900/30"
              style={{ backfaceVisibility: "hidden" }}
            >
              <p className="text-[13px] text-white/60 mb-2">Deutsch</p>
              <h2 className="text-white text-[28px] text-center">{currentWord.german}</h2>
              <p className="text-white/60 text-[13px] mt-2">{currentWord.phonetic}</p>
              <p className="text-white/40 text-[12px] mt-6">Tippen zum Umdrehen</p>
            </div>
            {/* Back */}
            <div
              className="bg-gradient-to-br from-green-500 to-teal-600 rounded-3xl p-8 min-h-[280px] flex flex-col items-center justify-center shadow-2xl shadow-green-200 dark:shadow-green-900/30 absolute inset-0"
              style={{ backfaceVisibility: "hidden", transform: "rotateY(180deg)" }}
            >
              <p className="text-[13px] text-white/60 mb-2">{langLabel}</p>
              <h2 className={`text-white text-[24px] text-center ${isDari ? "font-['Vazirmatn',sans-serif]" : ""}`}>{getTranslation(currentWord)}</h2>
              <div className="mt-4 bg-white/20 rounded-2xl px-4 py-3">
                <p className="text-white/90 text-[13px] text-center">{currentWord.example}</p>
              </div>
              <span className="mt-3 bg-white/20 px-3 py-1 rounded-full text-[11px] text-white">{currentWord.tag}</span>
            </div>
          </motion.div>
        </div>

        {/* Difficulty Buttons */}
        <div className="flex gap-3 mt-6 mb-4">
          <button
            onClick={() => handleFlashcardNext("hard")}
            className="flex-1 bg-red-100 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-2xl py-4 flex flex-col items-center gap-1 active:scale-95 transition-transform"
          >
            <span className="text-[20px]">❌</span>
            <span className="text-[12px]">Schwer</span>
          </button>
          <button
            onClick={() => handleFlashcardNext("medium")}
            className="flex-1 bg-yellow-100 dark:bg-yellow-900/20 text-yellow-600 dark:text-yellow-400 rounded-2xl py-4 flex flex-col items-center gap-1 active:scale-95 transition-transform"
          >
            <span className="text-[20px]">🤔</span>
            <span className="text-[12px]">Mittel</span>
          </button>
          <button
            onClick={() => handleFlashcardNext("easy")}
            className="flex-1 bg-green-100 dark:bg-green-900/20 text-green-600 dark:text-green-400 rounded-2xl py-4 flex flex-col items-center gap-1 active:scale-95 transition-transform"
          >
            <span className="text-[20px]">✅</span>
            <span className="text-[12px]">Leicht</span>
          </button>
        </div>
      </div>
    );
  }

  // Word Detail Modal
  if (selectedWord) {
    return (
      <div className="px-5 pt-6 pb-4 space-y-5">
        <div className="flex items-center gap-3">
          <button onClick={() => setSelectedWord(null)} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
            <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
          </button>
          <div className="flex-1" />
          <button onClick={() => toggleFavorite(selectedWord.id)} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
            <Heart size={20} className={selectedWord.isFavorite ? "fill-red-500 text-red-500" : "text-gray-400"} />
          </button>
        </div>

        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="bg-gradient-to-br from-blue-500 to-purple-600 rounded-3xl p-6 text-center shadow-lg">
          <h1 className="text-white text-[30px]">{selectedWord.german}</h1>
          <p className="text-white/60 text-[14px] mt-1">{selectedWord.phonetic}</p>
          <button className="mt-3 bg-white/20 rounded-full p-3 active:bg-white/30 transition-colors">
            <Volume2 size={20} className="text-white" />
          </button>
        </motion.div>

        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-sm">
          <h3 className="text-gray-900 dark:text-white mb-1">Bedeutung</h3>
          <p className={`text-[15px] text-gray-600 dark:text-gray-300 ${isDari ? "font-['Vazirmatn',sans-serif] text-right" : ""}`}>{getTranslation(selectedWord)}</p>
        </motion.div>

        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }} className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-sm">
          <h3 className="text-gray-900 dark:text-white mb-1">Beispielsatz</h3>
          <p className="text-[14px] text-gray-600 dark:text-gray-300 italic">"{selectedWord.example}"</p>
        </motion.div>

        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} className="bg-white dark:bg-slate-900 rounded-3xl p-5 shadow-sm">
          <h3 className="text-gray-900 dark:text-white mb-1">Business-Kontext</h3>
          <p className={`text-[14px] text-gray-600 dark:text-gray-300 ${isDari ? "font-['Vazirmatn',sans-serif] text-right" : ""}`}>{getContext(selectedWord)}</p>
          <span className="inline-block mt-2 bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 px-3 py-1 rounded-full text-[12px]">{selectedWord.tag}</span>
        </motion.div>

        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.25 }} className="flex gap-3">
          <select
            value={selectedWord.difficulty}
            onChange={e => setWordDifficulty(selectedWord.id, e.target.value as "easy" | "medium" | "hard")}
            className="flex-1 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-2xl px-4 py-3 text-[14px] text-gray-700 dark:text-gray-200"
          >
            <option value="easy">Leicht</option>
            <option value="medium">Mittel</option>
            <option value="hard">Schwer</option>
          </select>
          <button
            onClick={() => { setFlashcardMode(true); setSelectedWord(null); }}
            className="flex-1 bg-gradient-to-r from-blue-500 to-purple-500 text-white rounded-2xl py-3 text-[14px] active:scale-[0.98] transition-transform"
          >
            Flashcard starten
          </button>
        </motion.div>
      </div>
    );
  }

  // Main Vocabulary View
  return (
    <div className="px-5 pt-6 pb-4 space-y-5">
      {/* Header */}
      <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} className="flex items-center gap-3">
        <button onClick={() => navigate("/")} className="p-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm">
          <ArrowLeft size={20} className="text-gray-600 dark:text-gray-300" />
        </button>
        <div className="flex-1">
          <h1 className="text-[24px] text-gray-900 dark:text-white">Wortschatz 📚</h1>
          <p className="text-[13px] text-gray-500 dark:text-gray-400">Wörter & Business</p>
        </div>
        {/* Language Switcher */}
        <button
          onClick={() => setNativeLanguage(isDari ? "en" : "dari")}
          className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-white dark:bg-slate-800 shadow-sm active:scale-95 transition-transform"
        >
          <Languages size={16} className="text-blue-500" />
          <span className="text-[12px] text-gray-700 dark:text-gray-300">{isDari ? "دری" : "EN"}</span>
        </button>
      </motion.div>

      {/* Search */}
      <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.05 }} className="relative">
        <Search size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
        <input
          type="text"
          placeholder="Wort suchen..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          className="w-full bg-white dark:bg-slate-800 rounded-2xl pl-11 pr-4 py-3 text-[14px] text-gray-700 dark:text-gray-200 shadow-sm border-0 focus:ring-2 focus:ring-blue-500/30"
        />
      </motion.div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 dark:bg-slate-800 rounded-2xl p-1">
        {tabs.map(t => (
          <button
            key={t.key}
            onClick={() => { setTab(t.key); setSelectedCategory(null); }}
            className={`flex-1 py-2 rounded-xl text-[12px] transition-all ${
              tab === t.key ? "bg-white dark:bg-slate-700 text-blue-600 dark:text-blue-400 shadow-sm" : "text-gray-500 dark:text-gray-400"
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* Business Categories */}
      {tab === "words" && !selectedCategory && (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.1 }}>
          <h3 className="text-gray-900 dark:text-white mb-3">Business-Kategorien</h3>
          <div className="grid grid-cols-2 gap-2.5">
            {businessCategories.map((cat, idx) => (
              <motion.button
                key={cat.name}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.15 + idx * 0.04 }}
                whileTap={{ scale: 0.95 }}
                onClick={() => setSelectedCategory(cat.name)}
                className={`bg-gradient-to-br ${cat.color} rounded-2xl p-3.5 text-left shadow-md`}
              >
                <span className="text-[24px]">{cat.icon}</span>
                <p className="text-white text-[13px] mt-1.5">{cat.name}</p>
                <p className="text-white/60 text-[11px]">{cat.count} Wörter</p>
              </motion.button>
            ))}
          </div>
        </motion.div>
      )}

      {/* Category header */}
      {selectedCategory && (
        <div className="flex items-center gap-2">
          <button onClick={() => setSelectedCategory(null)} className="text-[13px] text-blue-500">Alle Kategorien</button>
          <ChevronRight size={14} className="text-gray-300" />
          <span className="text-[13px] text-gray-700 dark:text-gray-300">{selectedCategory}</span>
        </div>
      )}

      {/* Phrases Tab */}
      {tab === "phrases" && (
        <div className="space-y-2.5">
          {phrases.map((p, idx) => (
            <motion.div
              key={p.id}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.05 }}
              className="bg-white dark:bg-slate-900 rounded-2xl p-4 shadow-sm"
            >
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-[15px] text-gray-900 dark:text-white">{p.german}</p>
                  <p className={`text-[13px] text-gray-500 dark:text-gray-400 mt-0.5 ${isDari ? "font-['Vazirmatn',sans-serif]" : ""}`}>{isDari ? p.dari : p.english}</p>
                </div>
                <span className="text-[10px] bg-purple-100 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400 px-2 py-0.5 rounded-full">{p.tag}</span>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Words / Favorites / Difficult */}
      {tab !== "phrases" && (selectedCategory || tab !== "words") && (
        <div className="space-y-2.5">
          {filteredWords.map((word, idx) => (
            <motion.button
              key={word.id}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.04 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => setSelectedWord(word)}
              className="w-full bg-white dark:bg-slate-900 rounded-2xl p-4 shadow-sm flex items-center gap-3 text-left"
            >
              <div className="flex-1 min-w-0">
                <p className="text-[16px] text-gray-900 dark:text-white truncate">{word.german}</p>
                <p className="text-[11px] text-gray-400 dark:text-gray-500">{word.phonetic}</p>
                <p className={`text-[13px] text-gray-500 dark:text-gray-400 mt-0.5 ${isDari ? "font-['Vazirmatn',sans-serif]" : ""}`}>{getTranslation(word)}</p>
              </div>
              <span className={`text-[10px] px-2 py-0.5 rounded-full ${
                word.tag === "HR" ? "bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400" :
                word.tag === "Finance" ? "bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400" :
                word.tag === "IT" ? "bg-cyan-100 dark:bg-cyan-900/30 text-cyan-600 dark:text-cyan-400" :
                word.tag === "Legal" ? "bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400" :
                word.tag === "Marketing" ? "bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400" :
                word.tag === "Sales" ? "bg-amber-100 dark:bg-amber-900/30 text-amber-600 dark:text-amber-400" :
                word.tag === "Education" ? "bg-indigo-100 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400" :
                "bg-purple-100 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400"
              }`}>{word.tag}</span>
              <button
                onClick={e => { e.stopPropagation(); toggleFavorite(word.id); }}
                className="p-1.5"
              >
                <Heart size={16} className={word.isFavorite ? "fill-red-500 text-red-500" : "text-gray-300 dark:text-gray-600"} />
              </button>
            </motion.button>
          ))}
          {filteredWords.length === 0 && (
            <div className="text-center py-12">
              <p className="text-[40px]">{tab === "favorites" ? "💝" : tab === "difficult" ? "💪" : "🔍"}</p>
              <p className="text-gray-400 mt-2">{tab === "favorites" ? "Keine Favoriten" : tab === "difficult" ? "Keine schwierigen Wörter" : "Keine Ergebnisse"}</p>
            </div>
          )}
        </div>
      )}

      {/* Flashcard FAB */}
      <motion.button
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{ delay: 0.5, type: "spring" }}
        whileTap={{ scale: 0.9 }}
        onClick={() => setFlashcardMode(true)}
        className="fixed bottom-24 right-6 w-14 h-14 rounded-full bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-lg shadow-blue-300 dark:shadow-blue-900/50 flex items-center justify-center z-40"
      >
        <Plus size={24} />
      </motion.button>
    </div>
  );
}