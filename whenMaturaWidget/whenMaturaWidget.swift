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
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Calendar.current.startOfDay(for: .now)
        for dayOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct whenMaturaWidgetEntryView : View {
    var entry: Provider.Entry
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")
    let theme = ThemeManager.shared.current
    
    var maturaDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return Calendar.current.startOfDay(for: formatter.date(from: defaults?.string(forKey: "maturaDate") ?? "2170-05-04")!)
    }
    var todayBeginning: Date {
        return Calendar.current.startOfDay(for: .now)
    }

    var body: some View {
        VStack {
            Text("\(daysBetween(start: todayBeginning, end: maturaDate))")
                .foregroundColor(theme.primary)
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text("dni do matury")
                .foregroundColor(theme.secondary)
                .font(.system(.caption, design: .rounded))
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background { theme.background }
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
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
        whenMaturaWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
