//
//  whenMaturaWidget.swift
//  whenMaturaWidget
//
//  Created by Marcin Bartminski on 30/03/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), theme: .defaultTheme)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), theme: .defaultTheme)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")
        var entries: [SimpleEntry] = []

        let currentDate = Calendar.current.startOfDay(for: .now)
        for dayOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let themeCode = defaults?.integer(forKey: "themeCode") ?? 0
            let entry = SimpleEntry(date: entryDate, theme: ThemeManager.shared.decodeTheme(from: themeCode))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let theme: Theme
}

struct whenMaturaWidgetEntryView : View {
    var entry: Provider.Entry
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")
    
    var maturaDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let dateString = defaults?.string(forKey: "maturaDate") {
            return Calendar.current.startOfDay(for: formatter.date(from: dateString)!)
        } else {
            return nil
        }
    }
    var todayBeginning: Date {
        return Calendar.current.startOfDay(for: entry.date)
    }
    
    var matura: MaturaManager { MaturaManager(startDate: maturaDate, todayBeginning: todayBeginning) }

    var body: some View {
        VStack {
            Text("\(matura.currentState != .none ? String(matura.days) : "XX")")
                .foregroundColor(entry.theme.primary)
                .font(.system(size: 70, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(matura.texts.bottom)
                .foregroundColor(entry.theme.secondary)
                .font(.system(.body, design: .rounded))
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background { entry.theme.background }
    }
    
    func daysBetween(start: Date, end: Date?) -> Int? {
        if let endDate = end {
            return Calendar.current.dateComponents([.day], from: start, to: endDate).day!
        } else {
            return nil
        }
    }
}

struct whenMaturaWidget: Widget {
    let kind: String = "whenMaturaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            whenMaturaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Odliczanie")
        .description("Odliczanie do Twojej matury z wybranym w aplikacji motywem.")
        .supportedFamilies([.systemSmall])
    }
}

struct whenMaturaWidget_Previews: PreviewProvider {
    static var previews: some View {
        whenMaturaWidgetEntryView(entry: SimpleEntry(date: Date(), theme: .defaultTheme))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
