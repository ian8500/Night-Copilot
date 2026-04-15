import SwiftUI

struct AIChatView: View {
    @StateObject var viewModel: AIChatViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: Spacing.small) {
                        ForEach(viewModel.messages) { message in
                            messageBubble(message)
                                .id(message.id)
                        }
                    }
                    .padding(Spacing.medium)
                }
                .onChange(of: viewModel.messages.count) {
                    if let lastID = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }

            quickReplies
            composer
        }
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .navigationTitle("Ask Copilot")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func messageBubble(_ message: AIChatMessage) -> some View {
        HStack {
            if message.role == .user { Spacer(minLength: 36) }

            Text(message.text)
                .font(Typography.body)
                .foregroundStyle(.white)
                .padding(Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(backgroundColor(for: message.role))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.10), lineWidth: 1)
                        )
                )
                .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)

            if message.role != .user { Spacer(minLength: 36) }
        }
    }

    private var quickReplies: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xSmall) {
                ForEach(viewModel.quickReplies, id: \.self) { quickReply in
                    QuickActionChip(title: quickReply) {
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
            TextField("Share what’s happening…", text: $viewModel.inputText, axis: .vertical)
                .lineLimit(1...4)
                .font(Typography.body)
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.10))
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
            return Color.cardBackground
        case .user:
            return Color.mutedIndigo.opacity(0.45)
        case .safety:
            return Color(red: 0.45, green: 0.17, blue: 0.18).opacity(0.9)
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
