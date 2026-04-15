import SwiftUI

struct AIChatView: View {
    @StateObject var viewModel: AIChatViewModel
    @State private var isShowingPremiumSheet = false

    var body: some View {
        VStack(spacing: 0) {
            trustBanner

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: Spacing.small) {
                        ForEach(viewModel.messages) { message in
                            messageBubble(message)
                                .id(message.id)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        if viewModel.isSending {
                            typingIndicator
                        }
                    }
                    .padding(Spacing.medium)
                }
                .onChange(of: viewModel.messages.count) {
                    if let lastID = viewModel.messages.last?.id {
                        withAnimation(.easeOut(duration: 0.25)) {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }

            quickReplies
            composer
        }
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .navigationTitle("AI Copilot")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingPremiumSheet) {
            PremiumTierSheet(
                title: "Night Copilot Plus",
                subtitle: "Preview deeper Copilot sessions and personalization. Calm support stays available in Free."
            )
            .presentationDetents([.medium, .large])
        }
    }

    private var trustBanner: some View {
        VStack(spacing: 6) {
            HStack(spacing: Spacing.small) {
                Image(systemName: "checkmark.shield")
                    .foregroundStyle(Color.accentGlow)

                Text("Calm Copilot Free: private, judgment-free support for tonight.")
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.secondaryText)

                Spacer()
            }

            HStack {
                Button("Preview Plus features") {
                    isShowingPremiumSheet = true
                }
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.accentGlow)

                Spacer()
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(Color.white.opacity(0.04))
        .overlay(alignment: .bottom) {
            Divider().background(Color.white.opacity(0.1))
        }
    }

    private func messageBubble(_ message: AIChatMessage) -> some View {
        HStack(alignment: .bottom, spacing: Spacing.xSmall) {
            if message.role == .user { Spacer(minLength: 32) }

            if message.role != .user {
                bubbleIcon(for: message.role)
            }

            Text(message.text)
                .font(Typography.body)
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(backgroundColor(for: message.role))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
                .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .user {
                bubbleIcon(for: .user)
            }

            if message.role != .user { Spacer(minLength: 32) }
        }
    }

    private var typingIndicator: some View {
        HStack {
            bubbleIcon(for: .assistant)

            HStack(spacing: 5) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.secondaryText)
                        .frame(width: 6, height: 6)
                        .opacity(viewModel.isSending ? 0.45 + (Double(index) * 0.15) : 0.2)
                }
            }
            .padding(.horizontal, Spacing.small)
            .padding(.vertical, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.assistantBubble)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )

            Spacer()
        }
        .transition(.opacity)
    }

    private func bubbleIcon(for role: AIChatMessage.Role) -> some View {
        Image(systemName: role == .user ? "person.fill" : (role == .safety ? "exclamationmark.triangle.fill" : "sparkles"))
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 22, height: 22)
            .background(
                Circle()
                    .fill(backgroundColor(for: role).opacity(0.95))
            )
    }

    private var quickReplies: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xSmall) {
                ForEach(viewModel.quickReplies, id: \.self) { quickReply in
                    QuickActionChip(title: quickReply, subtitle: "Quick reply") {
                        Task { await viewModel.send(quickReply) }
                    }
                }
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.small)
        }
    }

    private var composer: some View {
        HStack(spacing: Spacing.small) {
            TextField("Type a short message…", text: $viewModel.inputText, axis: .vertical)
                .lineLimit(1...4)
                .font(Typography.body)
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        )
                )

            Button {
                Task { await viewModel.send() }
            } label: {
                Image(systemName: viewModel.isSending ? "hourglass" : "arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(Color.mutedIndigo)
                    )
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isSending)
        }
        .padding(Spacing.medium)
    }

    private func backgroundColor(for role: AIChatMessage.Role) -> Color {
        switch role {
        case .assistant:
            return Color.assistantBubble
        case .user:
            return Color.userBubble
        case .safety:
            return Color.safetyBubble.opacity(0.95)
        }
    }
}

#Preview {
    NavigationStack {
        AIChatView(
            viewModel: AIChatViewModel(
                context: CopilotContext(nightState: .cantSleep, currentPrompt: PromptLibrary.prompts.first)
            )
        )
    }
}
