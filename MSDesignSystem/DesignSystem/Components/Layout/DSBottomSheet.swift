// DSBottomSheet.swift
// DesignSystem/Components/Layout/DSBottomSheet.swift
//
// Модальный bottom sheet с drag-to-dismiss, опциональным поиском и кастомным контентом.
// Используется как base для DSSelect и других overlay-компонентов.

import SwiftUI

// MARK: - DSBottomSheet

struct DSBottomSheet<Content: View>: View {

    @Binding var isPresented: Bool
    let title: String?
    let showHandle: Bool
    let content: Content

    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false

    init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        showHandle: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.title = title
        self.showHandle = showHandle
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Dimmer
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                // Sheet
                VStack(spacing: 0) {
                    // Handle
                    if showHandle {
                        RoundedRectangle(cornerRadius: DS.Radius.full)
                            .fill(DS.Color.strokeSoft)
                            .frame(width: 36, height: 4)
                            .padding(.top, DS.Spacing.s12)
                            .padding(.bottom, DS.Spacing.s8)
                    }

                    // Title
                    if let title {
                        Text(title)
                            .dsFont(DS.Typography.labelMd)
                            .foregroundStyle(DS.Color.textMain)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, DS.Spacing.md)
                            .padding(.bottom, DS.Spacing.s12)
                    }

                    content
                }
                .background(DS.Color.bgWhite)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.xl, style: .continuous), style: FillStyle())
                .offset(y: max(0, dragOffset))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            isDragging = false
                            if value.translation.height > 120 {
                                dismiss()
                            } else {
                                withAnimation(DS.Animation.spring) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .transition(.move(edge: .bottom))
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .animation(DS.Animation.spring, value: isPresented)
    }

    private func dismiss() {
        withAnimation(DS.Animation.spring) {
            isPresented = false
            dragOffset = 0
        }
    }
}

// MARK: - ViewModifier

private struct DSBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let title: String?
    let showHandle: Bool
    let sheetContent: SheetContent

    init(
        isPresented: Binding<Bool>,
        title: String?,
        showHandle: Bool,
        @ViewBuilder content: () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.title = title
        self.showHandle = showHandle
        self.sheetContent = content()
    }

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            DSBottomSheet(isPresented: $isPresented, title: title, showHandle: showHandle) {
                sheetContent
            }
        }
    }
}

extension View {
    func dsBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        title: String? = nil,
        showHandle: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> some View {
        modifier(DSBottomSheetModifier(
            isPresented: isPresented,
            title: title,
            showHandle: showHandle,
            content: content
        ))
    }
}

// MARK: - Preview

#Preview("DSBottomSheet") {
    struct PreviewWrapper: View {
        @State private var showBasic = false
        @State private var showTitled = false

        var body: some View {
            VStack(spacing: DS.Spacing.md) {
                DSButton(title: "Открыть sheet", type: .primary, style: .filled) {
                    showBasic = true
                }
                DSButton(title: "С заголовком", type: .primary, style: .stroke) {
                    showTitled = true
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DS.Color.bgWeak)
            .dsBottomSheet(isPresented: $showBasic) {
                VStack(spacing: DS.Spacing.md) {
                    ForEach(["Опция 1", "Опция 2", "Опция 3"], id: \.self) { item in
                        HStack {
                            Text(item)
                                .dsFont(DS.Typography.paragraphMd)
                                .foregroundStyle(DS.Color.textMain)
                            Spacer()
                        }
                        .padding(.horizontal, DS.Spacing.md)
                        .padding(.vertical, DS.Spacing.s12)
                    }
                    Spacer().frame(height: DS.Spacing.xxl)
                }
            }
            .dsBottomSheet(isPresented: $showTitled, title: "Выберите опцию") {
                VStack(spacing: 0) {
                    ForEach(["Русский", "English", "Español"], id: \.self) { lang in
                        HStack {
                            Text(lang)
                                .dsFont(DS.Typography.paragraphMd)
                                .foregroundStyle(DS.Color.textMain)
                            Spacer()
                        }
                        .padding(.horizontal, DS.Spacing.md)
                        .frame(height: 48)
                        Divider().padding(.horizontal, DS.Spacing.md)
                    }
                    Spacer().frame(height: DS.Spacing.xxl)
                }
            }
        }
    }
    return PreviewWrapper()
}
