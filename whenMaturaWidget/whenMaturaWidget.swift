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
            let entry = SimpleEntry(date: entryDate, theme: ThemeManager().decodeTheme(from: themeCode))
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
    let entry: Provider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallMaturaView(date: entry.date, theme: entry.theme)
        case .accessoryCircular:
            CircularMaturaView(date: entry.date)
        default:
            EmptyView()
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
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct whenMaturaWidget_Previews: PreviewProvider {
    static var previews: some View {
        whenMaturaWidgetEntryView(entry: SimpleEntry(date: Date(), theme: .defaultTheme))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
