//
//  BibleVerses.swift
//  ClinicVisitTracker
//
//  Collection of inspirational Bible verses
//

import Foundation

struct BibleVerse: Identifiable {
    let id = UUID()
    let text: String
    let reference: String
}

class BibleVerses {
    static let shared = BibleVerses()

    let verses: [BibleVerse] = [
        BibleVerse(text: "I can do all things through Christ who strengthens me.", reference: "Philippians 4:13"),
        BibleVerse(text: "The LORD is my strength and my shield; my heart trusts in him, and he helps me.", reference: "Psalm 28:7"),
        BibleVerse(text: "Be strong and courageous. Do not be afraid; do not be discouraged, for the LORD your God will be with you wherever you go.", reference: "Joshua 1:9"),
        BibleVerse(text: "Trust in the LORD with all your heart and lean not on your own understanding.", reference: "Proverbs 3:5"),
        BibleVerse(text: "For I know the plans I have for you, declares the LORD, plans to prosper you and not to harm you, plans to give you hope and a future.", reference: "Jeremiah 29:11"),
        BibleVerse(text: "The LORD is my shepherd, I lack nothing.", reference: "Psalm 23:1"),
        BibleVerse(text: "Come to me, all you who are weary and burdened, and I will give you rest.", reference: "Matthew 11:28"),
        BibleVerse(text: "And we know that in all things God works for the good of those who love him.", reference: "Romans 8:28"),
        BibleVerse(text: "Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.", reference: "Philippians 4:6"),
        BibleVerse(text: "The name of the LORD is a fortified tower; the righteous run to it and are safe.", reference: "Proverbs 18:10"),
        BibleVerse(text: "He gives strength to the weary and increases the power of the weak.", reference: "Isaiah 40:29"),
        BibleVerse(text: "But those who hope in the LORD will renew their strength.", reference: "Isaiah 40:31"),
        BibleVerse(text: "The LORD himself goes before you and will be with you; he will never leave you nor forsake you.", reference: "Deuteronomy 31:8"),
        BibleVerse(text: "Cast all your anxiety on him because he cares for you.", reference: "1 Peter 5:7"),
        BibleVerse(text: "In their hearts humans plan their course, but the LORD establishes their steps.", reference: "Proverbs 16:9"),
        BibleVerse(text: "The LORD is close to the brokenhearted and saves those who are crushed in spirit.", reference: "Psalm 34:18"),
        BibleVerse(text: "God is our refuge and strength, an ever-present help in trouble.", reference: "Psalm 46:1"),
        BibleVerse(text: "Have I not commanded you? Be strong and courageous.", reference: "Joshua 1:9"),
        BibleVerse(text: "The steadfast love of the LORD never ceases; his mercies never come to an end.", reference: "Lamentations 3:22"),
        BibleVerse(text: "For God has not given us a spirit of fear, but of power and of love and of a sound mind.", reference: "2 Timothy 1:7"),
        BibleVerse(text: "And my God will meet all your needs according to the riches of his glory in Christ Jesus.", reference: "Philippians 4:19"),
        BibleVerse(text: "The LORD is my light and my salvation—whom shall I fear?", reference: "Psalm 27:1"),
        BibleVerse(text: "He heals the brokenhearted and binds up their wounds.", reference: "Psalm 147:3"),
        BibleVerse(text: "Let us not become weary in doing good, for at the proper time we will reap a harvest if we do not give up.", reference: "Galatians 6:9"),
        BibleVerse(text: "The LORD your God is with you, the Mighty Warrior who saves.", reference: "Zephaniah 3:17"),
        BibleVerse(text: "Peace I leave with you; my peace I give you.", reference: "John 14:27"),
        BibleVerse(text: "Therefore do not worry about tomorrow, for tomorrow will worry about itself.", reference: "Matthew 6:34"),
        BibleVerse(text: "Blessed is the one who perseveres under trial.", reference: "James 1:12"),
        BibleVerse(text: "The joy of the LORD is your strength.", reference: "Nehemiah 8:10"),
        BibleVerse(text: "Wait for the LORD; be strong and take heart and wait for the LORD.", reference: "Psalm 27:14"),
        BibleVerse(text: "He will wipe every tear from their eyes.", reference: "Revelation 21:4"),
        BibleVerse(text: "I have told you these things, so that in me you may have peace.", reference: "John 16:33"),
        BibleVerse(text: "Therefore encourage one another and build each other up.", reference: "1 Thessalonians 5:11"),
        BibleVerse(text: "Rejoice always, pray continually, give thanks in all circumstances.", reference: "1 Thessalonians 5:16-18"),
        BibleVerse(text: "Love is patient, love is kind.", reference: "1 Corinthians 13:4"),
        BibleVerse(text: "Whatever you do, work at it with all your heart, as working for the Lord.", reference: "Colossians 3:23"),
        BibleVerse(text: "The fruit of the Spirit is love, joy, peace, forbearance, kindness, goodness, faithfulness, gentleness and self-control.", reference: "Galatians 5:22-23"),
        BibleVerse(text: "A gentle answer turns away wrath, but a harsh word stirs up anger.", reference: "Proverbs 15:1"),
        BibleVerse(text: "This is the day the LORD has made; let us rejoice and be glad in it.", reference: "Psalm 118:24"),
        BibleVerse(text: "Humble yourselves before the Lord, and he will lift you up.", reference: "James 4:10"),
    ]

    func randomVerse() -> BibleVerse {
        return verses.randomElement() ?? verses[0]
    }
}
