import React, { createContext, useContext, useState, useCallback, type ReactNode } from "react";

// ============ TYPES ============
export interface VocabWord {
  id: string;
  german: string;
  phonetic: string;
  english: string;
  dari: string;
  category: string;
  tag: string;
  example: string;
  context: string;
  contextDari: string;
  difficulty: "easy" | "medium" | "hard";
  isFavorite: boolean;
  isDifficult: boolean;
}

export interface GrammarTopic {
  id: string;
  title: string;
  level: string;
  category: string;
  icon: string;
  rule: string;
  explanation: string;
  examples: string[];
  progress: number;
}

export interface Exercise {
  id: string;
  type: "multiple-choice" | "fill-blank" | "sentence-order" | "listening" | "business-dialog";
  question: string;
  options: string[];
  correctAnswer: number;
  topic: string;
  level: string;
}

export interface Achievement {
  id: string;
  title: string;
  description: string;
  icon: string;
  unlocked: boolean;
}

export interface UserStats {
  xp: number;
  streak: number;
  wordsLearned: number;
  exercisesCompleted: number;
  grammarTopicsCompleted: number;
  weeklyProgress: number;
  level: string;
  weakAreas: string[];
}

// ============ MOCK DATA ============
export const vocabularyData: VocabWord[] = [
  // === Bewerbung & Karriere ===
  { id: "v1", german: "die Bewerbung", phonetic: "/bəˈvɛʁbʊŋ/", english: "Application (job)", dari: "درخواستی (کاری)", category: "Bewerbung & Karriere", tag: "HR", example: "Ich schicke meine Bewerbung morgen ab.", context: "Used when applying for a job position.", contextDari: "هنگام درخواست دادن برای یک موقعیت کاری استفاده می‌شود.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v2", german: "das Vorstellungsgespräch", phonetic: "/ˈfoːɐ̯ʃtɛlʊŋsɡəˌʃpʁɛːç/", english: "Job interview", dari: "مصاحبه کاری", category: "Bewerbung & Karriere", tag: "HR", example: "Mein Vorstellungsgespräch ist am Montag.", context: "The formal meeting between employer and candidate.", contextDari: "ملاقات رسمی بین کارفرما و کاندید.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v10", german: "die Gehaltserhöhung", phonetic: "/ɡəˈhaltsɛɐ̯høːʊŋ/", english: "Salary raise", dari: "افزایش معاش", category: "Bewerbung & Karriere", tag: "HR", example: "Ich möchte eine Gehaltserhöhung besprechen.", context: "An increase in one's salary.", contextDari: "افزایش در معاش یک شخص.", difficulty: "hard", isFavorite: false, isDifficult: true },
  { id: "v14", german: "der Geschäftsführer", phonetic: "/ɡəˈʃɛftsˌfyːʁɐ/", english: "Managing Director / CEO", dari: "مدیر عامل / رئیس اجرایی", category: "Bewerbung & Karriere", tag: "HR", example: "Der Geschäftsführer hält eine Rede.", context: "The person in charge of running a company.", contextDari: "شخصی که مسئول اداره یک شرکت است.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v17", german: "der Lebenslauf", phonetic: "/ˈleːbn̩sˌlaʊ̯f/", english: "CV / Resume", dari: "خلص سوانح", category: "Bewerbung & Karriere", tag: "HR", example: "Bitte senden Sie Ihren Lebenslauf.", context: "A summary of your education and work experience.", contextDari: "خلاصه‌ای از تحصیلات و تجربه کاری شما.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v18", german: "die Beförderung", phonetic: "/bəˈfœʁdəʁʊŋ/", english: "Promotion", dari: "ترفیع", category: "Bewerbung & Karriere", tag: "HR", example: "Sie hat eine Beförderung bekommen.", context: "Advancing to a higher position at work.", contextDari: "ارتقا به یک موقعیت بالاتر در کار.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v19", german: "die Arbeitserfahrung", phonetic: "/ˈaʁbaɪ̯tsɛɐ̯ˌfaːʁʊŋ/", english: "Work experience", dari: "تجربه کاری", category: "Bewerbung & Karriere", tag: "HR", example: "Er hat viel Arbeitserfahrung.", context: "Previous professional experience.", contextDari: "تجربه حرفه‌ای قبلی.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v20", german: "das Gehalt", phonetic: "/ɡəˈhalt/", english: "Salary", dari: "معاش", category: "Bewerbung & Karriere", tag: "HR", example: "Das Gehalt wird am Monatsende gezahlt.", context: "Monthly payment for employment.", contextDari: "پرداخت ماهانه برای استخدام.", difficulty: "easy", isFavorite: false, isDifficult: false },

  // === Meetings ===
  { id: "v3", german: "die Besprechung", phonetic: "/bəˈʃpʁɛçʊŋ/", english: "Meeting", dari: "جلسه", category: "Meetings", tag: "Office", example: "Die Besprechung beginnt um 10 Uhr.", context: "A formal meeting in a business setting.", contextDari: "یک جلسه رسمی در محیط کاری.", difficulty: "easy", isFavorite: true, isDifficult: false },
  { id: "v21", german: "die Tagesordnung", phonetic: "/ˈtaːɡəsˌʔɔʁdnʊŋ/", english: "Agenda", dari: "آجندا / دستور کار", category: "Meetings", tag: "Office", example: "Die Tagesordnung für heute steht fest.", context: "The list of topics to discuss in a meeting.", contextDari: "فهرست موضوعاتی که در جلسه بحث می‌شود.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v22", german: "das Protokoll", phonetic: "/pʁotoˈkɔl/", english: "Minutes / Protocol", dari: "پروتوکول / صورتجلسه", category: "Meetings", tag: "Office", example: "Wer schreibt das Protokoll?", context: "The written record of a meeting.", contextDari: "سند مکتوب از یک جلسه.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v23", german: "die Präsentation", phonetic: "/pʁɛzɛntaˈt͡si̯oːn/", english: "Presentation", dari: "ارائه / پرزنتیشن", category: "Meetings", tag: "Office", example: "Die Präsentation war sehr informativ.", context: "A formal talk or demonstration.", contextDari: "یک صحبت رسمی یا نمایش.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v24", german: "der Teilnehmer", phonetic: "/ˈtaɪ̯lˌneːmɐ/", english: "Participant", dari: "اشتراک‌کننده", category: "Meetings", tag: "Office", example: "Alle Teilnehmer sind eingeladen.", context: "A person who takes part in a meeting or event.", contextDari: "شخصی که در یک جلسه یا رویداد شرکت می‌کند.", difficulty: "easy", isFavorite: false, isDifficult: false },

  // === Finanzen ===
  { id: "v4", german: "der Umsatz", phonetic: "/ˈʊmzats/", english: "Revenue / Turnover", dari: "عواید / گردش مالی", category: "Finanzen", tag: "Finance", example: "Der Umsatz ist dieses Quartal gestiegen.", context: "Total revenue generated by a company.", contextDari: "مجموع عواید تولید شده توسط یک شرکت.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v5", german: "die Rechnung", phonetic: "/ˈʁɛçnʊŋ/", english: "Invoice / Bill", dari: "فاکتور / صورتحساب", category: "Finanzen", tag: "Finance", example: "Bitte senden Sie mir die Rechnung.", context: "A document requesting payment for goods/services.", contextDari: "سندی که درخواست پرداخت برای کالا/خدمات می‌کند.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v15", german: "die Buchhaltung", phonetic: "/ˈbuːxhaltʊŋ/", english: "Accounting", dari: "حسابداری", category: "Finanzen", tag: "Finance", example: "Die Buchhaltung prüft die Ausgaben.", context: "The department handling financial records.", contextDari: "بخشی که سوابق مالی را اداره می‌کند.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v25", german: "die Steuer", phonetic: "/ˈʃtɔɪ̯ɐ/", english: "Tax", dari: "مالیات", category: "Finanzen", tag: "Finance", example: "Die Steuer muss pünktlich bezahlt werden.", context: "A compulsory payment to the government.", contextDari: "پرداخت اجباری به دولت.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v26", german: "der Gewinn", phonetic: "/ɡəˈvɪn/", english: "Profit", dari: "سود / فایده", category: "Finanzen", tag: "Finance", example: "Der Gewinn ist um 20% gestiegen.", context: "Financial gain after expenses.", contextDari: "سود مالی بعد از مصارف.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v27", german: "die Überweisung", phonetic: "/yːbɐˈvaɪ̯zʊŋ/", english: "Bank transfer", dari: "انتقال بانکی", category: "Finanzen", tag: "Finance", example: "Die Überweisung wurde heute durchgeführt.", context: "The electronic transfer of funds.", contextDari: "انتقال الکترونیکی وجوه.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v28", german: "das Budget", phonetic: "/bʏˈdʒeː/", english: "Budget", dari: "بودجه", category: "Finanzen", tag: "Finance", example: "Wir müssen das Budget einhalten.", context: "The financial plan for a project.", contextDari: "پلان مالی برای یک پروژه.", difficulty: "easy", isFavorite: false, isDifficult: false },

  // === Büro Kommunikation ===
  { id: "v7", german: "die Frist", phonetic: "/fʁɪst/", english: "Deadline", dari: "مهلت", category: "Büro Kommunikation", tag: "Office", example: "Die Frist endet am Freitag.", context: "A time limit for completing a task.", contextDari: "محدودیت زمانی برای تکمیل یک کار.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v13", german: "die Zusammenarbeit", phonetic: "/tsuˈzamənʔaʁbaɪ̯t/", english: "Collaboration", dari: "همکاری", category: "Büro Kommunikation", tag: "Office", example: "Die Zusammenarbeit mit dem Team war hervorragend.", context: "Working together with others on a project.", contextDari: "کار کردن با دیگران روی یک پروژه.", difficulty: "medium", isFavorite: true, isDifficult: false },
  { id: "v29", german: "der Kollege", phonetic: "/kɔˈleːɡə/", english: "Colleague", dari: "همکار", category: "Büro Kommunikation", tag: "Office", example: "Mein Kollege hilft mir bei dem Projekt.", context: "A person you work with.", contextDari: "شخصی که با او کار می‌کنید.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v30", german: "die Aufgabe", phonetic: "/ˈaʊ̯fˌɡaːbə/", english: "Task / Assignment", dari: "وظیفه / تکلیف", category: "Büro Kommunikation", tag: "Office", example: "Ich habe eine neue Aufgabe bekommen.", context: "A piece of work to be done.", contextDari: "یک کار که باید انجام شود.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v31", german: "die E-Mail", phonetic: "/ˈiːmeɪ̯l/", english: "Email", dari: "ایمیل", category: "Büro Kommunikation", tag: "Office", example: "Ich schreibe Ihnen eine E-Mail.", context: "Electronic message communication.", contextDari: "ارتباطات پیام الکترونیکی.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v32", german: "die Abteilung", phonetic: "/ˈaptaɪ̯lʊŋ/", english: "Department", dari: "بخش / دیپارتمنت", category: "Büro Kommunikation", tag: "Office", example: "Welche Abteilung leiten Sie?", context: "A division of a company.", contextDari: "یک بخش از شرکت.", difficulty: "medium", isFavorite: false, isDifficult: false },

  // === IT & Technik ===
  { id: "v8", german: "die Datenbank", phonetic: "/ˈdaːtn̩baŋk/", english: "Database", dari: "پایگاه داده", category: "IT & Technik", tag: "IT", example: "Die Datenbank wurde aktualisiert.", context: "A structured collection of digital data.", contextDari: "مجموعه ساختار یافته از داده‌های دیجیتال.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v16", german: "die Sicherheit", phonetic: "/ˈzɪçɐhaɪ̯t/", english: "Security / Safety", dari: "امنیت / مصئونیت", category: "IT & Technik", tag: "IT", example: "Die Sicherheit der Daten hat Priorität.", context: "Protection of data and systems.", contextDari: "محافظت از داده‌ها و سیستم‌ها.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v33", german: "die Software", phonetic: "/ˈzɔftvɛːɐ̯/", english: "Software", dari: "نرم‌افزار", category: "IT & Technik", tag: "IT", example: "Die Software muss aktualisiert werden.", context: "Computer programs and applications.", contextDari: "برنامه‌ها و اپلیکیشن‌های کامپیوتری.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v34", german: "das Netzwerk", phonetic: "/ˈnɛt͡svɛʁk/", english: "Network", dari: "شبکه", category: "IT & Technik", tag: "IT", example: "Das Netzwerk ist ausgefallen.", context: "A system of connected computers.", contextDari: "سیستمی از کامپیوترهای وصل شده.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v35", german: "der Benutzer", phonetic: "/bəˈnʊt͡sɐ/", english: "User", dari: "کاربر / استفاده‌کننده", category: "IT & Technik", tag: "IT", example: "Der Benutzer muss sich anmelden.", context: "A person who uses a system.", contextDari: "شخصی که از یک سیستم استفاده می‌کند.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v36", german: "die Schnittstelle", phonetic: "/ˈʃnɪtˌʃtɛlə/", english: "Interface / API", dari: "واسط / رابط", category: "IT & Technik", tag: "IT", example: "Die Schnittstelle funktioniert einwandfrei.", context: "A point of interaction between systems.", contextDari: "نقطه تعامل بین سیستم‌ها.", difficulty: "hard", isFavorite: false, isDifficult: true },

  // === Verträge ===
  { id: "v6", german: "der Vertrag", phonetic: "/fɛɐ̯ˈtʁaːk/", english: "Contract", dari: "قرارداد", category: "Verträge", tag: "Legal", example: "Wir müssen den Vertrag unterschreiben.", context: "A legally binding agreement between parties.", contextDari: "یک توافقنامه قانونی بین طرف‌ها.", difficulty: "easy", isFavorite: true, isDifficult: false },
  { id: "v11", german: "die Kündigung", phonetic: "/ˈkʏndɪɡʊŋ/", english: "Termination / Resignation", dari: "فسخ / استعفا", category: "Verträge", tag: "Legal", example: "Die Kündigung muss schriftlich erfolgen.", context: "The act of ending an employment or contract.", contextDari: "عمل پایان دادن به استخدام یا قرارداد.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v37", german: "die Klausel", phonetic: "/ˈklaʊ̯zl̩/", english: "Clause", dari: "ماده / بند", category: "Verträge", tag: "Legal", example: "Diese Klausel ist sehr wichtig.", context: "A specific section within a contract.", contextDari: "یک بخش خاص در قرارداد.", difficulty: "hard", isFavorite: false, isDifficult: true },
  { id: "v38", german: "die Unterschrift", phonetic: "/ˈʊntɐˌʃʁɪft/", english: "Signature", dari: "امضا", category: "Verträge", tag: "Legal", example: "Ihre Unterschrift fehlt noch.", context: "A handwritten sign to confirm agreement.", contextDari: "نشانه دست‌نویس برای تأیید توافق.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v39", german: "die Haftung", phonetic: "/ˈhaftʊŋ/", english: "Liability", dari: "مسئولیت", category: "Verträge", tag: "Legal", example: "Die Haftung ist begrenzt.", context: "Legal responsibility for something.", contextDari: "مسئولیت قانونی برای چیزی.", difficulty: "hard", isFavorite: false, isDifficult: true },

  // === Marketing ===
  { id: "v9", german: "die Zielgruppe", phonetic: "/ˈtsiːlɡʁʊpə/", english: "Target group / audience", dari: "گروه هدف / مخاطبان", category: "Marketing", tag: "Marketing", example: "Wir müssen unsere Zielgruppe besser verstehen.", context: "The intended audience for a product or campaign.", contextDari: "مخاطبان مورد نظر برای یک محصول یا کمپاین.", difficulty: "medium", isFavorite: false, isDifficult: true },
  { id: "v12", german: "das Angebot", phonetic: "/ˈanɡəboːt/", english: "Offer / Proposal", dari: "پیشنهاد / آفر", category: "Marketing", tag: "Sales", example: "Wir haben ein neues Angebot erstellt.", context: "A business proposal or price quote.", contextDari: "یک پیشنهاد تجارتی یا قیمت‌گذاری.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v40", german: "die Werbung", phonetic: "/ˈvɛʁbʊŋ/", english: "Advertising", dari: "تبلیغات", category: "Marketing", tag: "Marketing", example: "Die Werbung läuft im Fernsehen.", context: "Promoting products or services.", contextDari: "ترویج محصولات یا خدمات.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v41", german: "die Marke", phonetic: "/ˈmaʁkə/", english: "Brand", dari: "برند / نشان تجارتی", category: "Marketing", tag: "Marketing", example: "Diese Marke ist weltweit bekannt.", context: "A recognizable name or symbol.", contextDari: "یک نام یا نماد قابل شناسایی.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v42", german: "der Wettbewerb", phonetic: "/ˈvɛtbəˌvɛʁp/", english: "Competition", dari: "رقابت", category: "Marketing", tag: "Marketing", example: "Der Wettbewerb ist sehr stark.", context: "Rivalry between businesses.", contextDari: "رقابت بین کسب‌وکارها.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v43", german: "der Kunde", phonetic: "/ˈkʊndə/", english: "Customer / Client", dari: "مشتری", category: "Marketing", tag: "Sales", example: "Der Kunde ist zufrieden.", context: "A person who buys goods or services.", contextDari: "شخصی که کالا یا خدمات می‌خرد.", difficulty: "easy", isFavorite: false, isDifficult: false },

  // === Bildung (Education) ===
  { id: "v44", german: "die Universität", phonetic: "/univɛʁziˈtɛːt/", english: "University", dari: "پوهنتون / دانشگاه", category: "Bildung", tag: "Education", example: "Ich studiere an der Universität.", context: "An institution of higher education.", contextDari: "یک نهاد آموزش عالی.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v45", german: "das Studium", phonetic: "/ˈʃtuːdi̯ʊm/", english: "Studies / Degree program", dari: "تحصیلات / رشته تحصیلی", category: "Bildung", tag: "Education", example: "Mein Studium dauert vier Jahre.", context: "Academic studies at a university.", contextDari: "تحصیلات اکادمیک در پوهنتون.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v46", german: "die Prüfung", phonetic: "/ˈpʁyːfʊŋ/", english: "Exam / Test", dari: "امتحان", category: "Bildung", tag: "Education", example: "Die Prüfung ist nächste Woche.", context: "A formal test of knowledge.", contextDari: "یک آزمون رسمی دانش.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v47", german: "das Stipendium", phonetic: "/ʃtiˈpɛndi̯ʊm/", english: "Scholarship", dari: "بورسیه تحصیلی", category: "Bildung", tag: "Education", example: "Sie hat ein Stipendium bekommen.", context: "Financial aid for students.", contextDari: "کمک مالی برای محصلین.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v48", german: "der Abschluss", phonetic: "/ˈapʃlʊs/", english: "Degree / Graduation", dari: "فارغ‌التحصیلی / سند تحصیلی", category: "Bildung", tag: "Education", example: "Er hat seinen Abschluss gemacht.", context: "Completion of an academic program.", contextDari: "تکمیل یک برنامه اکادمیک.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v49", german: "die Vorlesung", phonetic: "/ˈfoːɐ̯ˌleːzʊŋ/", english: "Lecture", dari: "لکچر / درس", category: "Bildung", tag: "Education", example: "Die Vorlesung beginnt um 9 Uhr.", context: "A university class or lecture.", contextDari: "یک صنف درسی یا لکچر پوهنتونی.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v50", german: "das Zeugnis", phonetic: "/ˈt͡sɔɪ̯ɡnɪs/", english: "Certificate / Report card", dari: "تصدیقنامه / کارنامه", category: "Bildung", tag: "Education", example: "Sein Zeugnis war ausgezeichnet.", context: "An official document of academic results.", contextDari: "یک سند رسمی از نتایج اکادمیک.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v51", german: "die Ausbildung", phonetic: "/ˈaʊ̯sbɪldʊŋ/", english: "Vocational training", dari: "آموزش مسلکی", category: "Bildung", tag: "Education", example: "Die Ausbildung dauert drei Jahre.", context: "Practical training for a profession.", contextDari: "آموزش عملی برای یک مسلک.", difficulty: "easy", isFavorite: false, isDifficult: false },
  { id: "v52", german: "der Dozent", phonetic: "/doˈt͡sɛnt/", english: "Lecturer / Professor", dari: "استاد / پروفیسور", category: "Bildung", tag: "Education", example: "Der Dozent erklärt das Thema.", context: "A teacher at a university.", contextDari: "یک معلم در پوهنتون.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v53", german: "die Hausarbeit", phonetic: "/ˈhaʊ̯sˌaʁbaɪ̯t/", english: "Term paper / Essay", dari: "مقاله تحصیلی / تکلیف خانگی", category: "Bildung", tag: "Education", example: "Ich muss meine Hausarbeit abgeben.", context: "A written academic assignment.", contextDari: "یک تکلیف اکادمیک مکتوب.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v54", german: "die Forschung", phonetic: "/ˈfɔʁʃʊŋ/", english: "Research", dari: "تحقیق / پژوهش", category: "Bildung", tag: "Education", example: "Die Forschung hat neue Ergebnisse gebracht.", context: "Systematic investigation to establish facts.", contextDari: "بررسی سیستماتیک برای تعیین حقایق.", difficulty: "medium", isFavorite: false, isDifficult: false },
  { id: "v55", german: "die Bibliothek", phonetic: "/biblioˈteːk/", english: "Library", dari: "کتابخانه", category: "Bildung", tag: "Education", example: "Ich lerne in der Bibliothek.", context: "A place with books and study resources.", contextDari: "مکانی با کتاب‌ها و منابع مطالعه.", difficulty: "easy", isFavorite: false, isDifficult: false },
];

export const grammarData: GrammarTopic[] = [
  { id: "g1", title: "Bestimmte Artikel", level: "A1", category: "Artikel", icon: "📘", rule: "Der (maskulin), Die (feminin), Das (neutrum) — bestimmte Artikel hängen vom Genus ab.", explanation: "In German, every noun has a grammatical gender. The definite articles are: der (masculine), die (feminine), das (neuter). In plural, all genders use 'die'.", examples: ["Der Mann liest ein Buch.", "Die Frau trinkt Kaffee.", "Das Kind spielt im Garten.", "Die Kinder gehen zur Schule."], progress: 80 },
  { id: "g2", title: "Präsens", level: "A1", category: "Zeiten", icon: "⏰", rule: "Im Präsens konjugiert man das Verb nach Person und Numerus.", explanation: "The present tense in German is formed by adding endings to the verb stem: -e, -st, -t, -en, -t, -en.", examples: ["Ich lerne Deutsch.", "Du arbeitest jeden Tag.", "Er spielt Fußball.", "Wir gehen ins Kino."], progress: 65 },
  { id: "g3", title: "Nebensätze mit 'weil'", level: "A2", category: "Nebensätze", icon: "🔗", rule: "Im Nebensatz steht das konjugierte Verb am Ende.", explanation: "When using subordinating conjunctions like 'weil' (because), 'dass' (that), 'wenn' (when/if), the conjugated verb moves to the end of the clause.", examples: ["Ich lerne Deutsch, weil ich in Berlin arbeite.", "Sie sagt, dass sie morgen kommt.", "Wenn es regnet, bleibe ich zu Hause."], progress: 40 },
  { id: "g4", title: "Wechselpräpositionen", level: "A2", category: "Präpositionen", icon: "📍", rule: "Wechselpräpositionen verwenden Akkusativ (Bewegung) oder Dativ (Position).", explanation: "Two-way prepositions (an, auf, hinter, in, neben, über, unter, vor, zwischen) take Accusative for movement and Dative for location.", examples: ["Ich stelle das Buch auf den Tisch. (Akk)", "Das Buch liegt auf dem Tisch. (Dat)", "Er geht in die Schule. (Akk)", "Er ist in der Schule. (Dat)"], progress: 30 },
  { id: "g5", title: "Perfekt", level: "A2", category: "Zeiten", icon: "⏰", rule: "Perfekt = haben/sein + Partizip II", explanation: "The Perfekt tense is formed with an auxiliary verb (haben or sein) and the past participle (Partizip II). Most verbs use 'haben', verbs of motion and change use 'sein'.", examples: ["Ich habe Deutsch gelernt.", "Sie ist nach Berlin gefahren.", "Wir haben einen Film gesehen.", "Er ist gestern angekommen."], progress: 55 },
  { id: "g6", title: "Konjunktiv II", level: "B1", category: "Konjunktiv", icon: "💭", rule: "Konjunktiv II drückt irreale Situationen, Wünsche und höfliche Bitten aus.", explanation: "Konjunktiv II is used for hypothetical situations, wishes, and polite requests. For most verbs, use 'würde' + infinitive. Common verbs have special forms: wäre, hätte, könnte.", examples: ["Wenn ich reich wäre, würde ich reisen.", "Ich hätte gern einen Kaffee.", "Könnten Sie mir bitte helfen?", "Wenn ich Zeit hätte, würde ich mehr lernen."], progress: 20 },
  { id: "g7", title: "Relativsätze", level: "B1", category: "Nebensätze", icon: "🔗", rule: "Relativpronomen richtet sich nach Genus/Numerus des Bezugswortes und Kasus im Relativsatz.", explanation: "Relative clauses provide additional information about a noun. The relative pronoun agrees in gender and number with the noun it refers to, but its case is determined by its function in the relative clause.", examples: ["Der Mann, der dort steht, ist mein Chef.", "Die Frau, die ich kenne, arbeitet bei Siemens.", "Das Buch, das ich lese, ist sehr interessant.", "Die Leute, denen ich geholfen habe, waren dankbar."], progress: 15 },
  { id: "g8", title: "Passiv", level: "B2", category: "Zeiten", icon: "⏰", rule: "Vorgangspassiv: werden + Partizip II / Zustandspassiv: sein + Partizip II", explanation: "German has two types of passive voice. Vorgangspassiv (process passive) focuses on the action, using 'werden' + past participle. Zustandspassiv (state passive) describes a result, using 'sein' + past participle.", examples: ["Das Auto wird repariert. (Vorgang)", "Das Auto ist repariert. (Zustand)", "Der Brief wurde gestern geschrieben.", "Die Tür ist geöffnet."], progress: 10 },
];

export const exerciseData: Exercise[] = [
  { id: "e1", type: "multiple-choice", question: "Was ist der Artikel von 'Bewerbung'?", options: ["der", "die", "das", "ein"], correctAnswer: 1, topic: "Artikel", level: "A1" },
  { id: "e2", type: "multiple-choice", question: "Ich ___ Deutsch. (lernen, Präsens)", options: ["lernt", "lerne", "lernst", "lernen"], correctAnswer: 1, topic: "Zeiten", level: "A1" },
  { id: "e3", type: "fill-blank", question: "Ich lerne Deutsch, ___ ich in Berlin arbeite.", options: ["weil", "obwohl", "damit", "wenn"], correctAnswer: 0, topic: "Nebensätze", level: "A2" },
  { id: "e4", type: "multiple-choice", question: "Welches Wort bedeutet 'Meeting'?", options: ["die Rechnung", "die Besprechung", "die Bewerbung", "der Vertrag"], correctAnswer: 1, topic: "Vocabulary", level: "A2" },
  { id: "e5", type: "fill-blank", question: "Ich stelle das Buch auf ___ Tisch. (Akkusativ)", options: ["dem", "den", "der", "das"], correctAnswer: 1, topic: "Präpositionen", level: "A2" },
  { id: "e6", type: "multiple-choice", question: "Wenn ich reich ___, würde ich reisen.", options: ["bin", "wäre", "sei", "war"], correctAnswer: 1, topic: "Konjunktiv", level: "B1" },
  { id: "e7", type: "sentence-order", question: "Ordnen Sie: ich / Deutsch / weil / arbeite / lerne / in Berlin / ich", options: ["Ich lerne Deutsch, weil ich in Berlin arbeite.", "Weil ich in Berlin arbeite, lerne ich Deutsch.", "Ich arbeite in Berlin, weil ich Deutsch lerne.", "Deutsch lerne ich, weil Berlin ich arbeite."], correctAnswer: 0, topic: "Nebensätze", level: "A2" },
  { id: "e8", type: "multiple-choice", question: "Was bedeutet 'der Umsatz'?", options: ["Salary", "Revenue", "Contract", "Deadline"], correctAnswer: 1, topic: "Vocabulary", level: "B1" },
  { id: "e9", type: "fill-blank", question: "Der Mann, ___ dort steht, ist mein Chef.", options: ["die", "das", "der", "dem"], correctAnswer: 2, topic: "Nebensätze", level: "B1" },
  { id: "e10", type: "multiple-choice", question: "Perfekt: Sie ___ nach Berlin gefahren.", options: ["hat", "ist", "wird", "war"], correctAnswer: 1, topic: "Zeiten", level: "A2" },
  { id: "e11", type: "business-dialog", question: "In einem Meeting sagen Sie: '___Sie mir bitte die Unterlagen schicken?'", options: ["Können", "Könnten", "Müssen", "Sollen"], correctAnswer: 1, topic: "Business", level: "B1" },
  { id: "e12", type: "multiple-choice", question: "Was bedeutet 'die Kündigung'?", options: ["Application", "Contract", "Termination", "Meeting"], correctAnswer: 2, topic: "Vocabulary", level: "B1" },
];

export const achievementData: Achievement[] = [
  { id: "a1", title: "Erste Schritte", description: "Complete your first lesson", icon: "🎯", unlocked: true },
  { id: "a2", title: "Wortmeister", description: "Learn 10 vocabulary words", icon: "📚", unlocked: true },
  { id: "a3", title: "Grammatik-Guru", description: "Complete 5 grammar topics", icon: "🧠", unlocked: false },
  { id: "a4", title: "Flammen-Held", description: "7-day learning streak", icon: "🔥", unlocked: true },
  { id: "a5", title: "Perfektionist", description: "Score 100% on an exercise", icon: "💎", unlocked: false },
  { id: "a6", title: "Business-Profi", description: "Learn all business vocabulary", icon: "💼", unlocked: false },
];

export const businessCategories = [
  { name: "Bewerbung & Karriere", color: "from-blue-500 to-blue-600", icon: "💼", count: 8 },
  { name: "Büro Kommunikation", color: "from-teal-500 to-teal-600", icon: "💬", count: 6 },
  { name: "Meetings", color: "from-purple-500 to-purple-600", icon: "🤝", count: 5 },
  { name: "IT & Technik", color: "from-cyan-500 to-cyan-600", icon: "💻", count: 6 },
  { name: "Finanzen", color: "from-green-500 to-green-600", icon: "💰", count: 7 },
  { name: "Verträge", color: "from-red-400 to-red-500", icon: "📄", count: 5 },
  { name: "Marketing", color: "from-orange-400 to-orange-500", icon: "📢", count: 6 },
  { name: "Bildung", color: "from-indigo-500 to-indigo-600", icon: "🎓", count: 12 },
];

// ============ CONTEXT ============
interface AppState {
  userStats: UserStats;
  vocabulary: VocabWord[];
  darkMode: boolean;
  nativeLanguage: "en" | "dari";
  toggleDarkMode: () => void;
  toggleFavorite: (id: string) => void;
  addXP: (amount: number) => void;
  incrementStreak: () => void;
  setWordDifficulty: (id: string, diff: "easy" | "medium" | "hard") => void;
  setNativeLanguage: (lang: "en" | "dari") => void;
}

const AppContext = createContext<AppState | null>(null);

export function AppProvider({ children }: { children: ReactNode }) {
  const [darkMode, setDarkMode] = useState(false);
  const [nativeLanguage, setNativeLanguageState] = useState<"en" | "dari">("en");
  const [vocabulary, setVocabulary] = useState<VocabWord[]>(vocabularyData);
  const [userStats, setUserStats] = useState<UserStats>({
    xp: 1250,
    streak: 5,
    wordsLearned: 55,
    exercisesCompleted: 23,
    grammarTopicsCompleted: 3,
    weeklyProgress: 68,
    level: "A2",
    weakAreas: ["Konjunktiv", "Nebensätze"],
  });

  const toggleDarkMode = useCallback(() => {
    setDarkMode(prev => {
      const next = !prev;
      if (next) {
        document.documentElement.classList.add("dark");
      } else {
        document.documentElement.classList.remove("dark");
      }
      return next;
    });
  }, []);

  const toggleFavorite = useCallback((id: string) => {
    setVocabulary(prev => prev.map(w => w.id === id ? { ...w, isFavorite: !w.isFavorite } : w));
  }, []);

  const addXP = useCallback((amount: number) => {
    setUserStats(prev => ({ ...prev, xp: prev.xp + amount }));
  }, []);

  const incrementStreak = useCallback(() => {
    setUserStats(prev => ({ ...prev, streak: prev.streak + 1 }));
  }, []);

  const setWordDifficulty = useCallback((id: string, diff: "easy" | "medium" | "hard") => {
    setVocabulary(prev => prev.map(w => w.id === id ? { ...w, difficulty: diff, isDifficult: diff === "hard" } : w));
  }, []);

  const setNativeLanguage = useCallback((lang: "en" | "dari") => {
    setNativeLanguageState(lang);
  }, []);

  return (
    <AppContext.Provider value={{ userStats, vocabulary, darkMode, nativeLanguage, toggleDarkMode, toggleFavorite, addXP, incrementStreak, setWordDifficulty, setNativeLanguage }}>
      {children}
    </AppContext.Provider>
  );
}

export function useAppState() {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error("useAppState must be used within AppProvider");
  return ctx;
}