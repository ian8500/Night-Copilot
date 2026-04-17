import SwiftUI

struct AIChatView: View {
    @StateObject var viewModel: AIChatViewModel

    var body: some View {
        VStack(spacing: 0) {
            modePicker

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: Spacing.small) {
                        ForEach(viewModel.messages) { message in
                            messageBubble(message)
                                .id(message.id)
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

            if !viewModel.isEscalated {
                quickReplies
                composer
            } else {
                escalationFooter
            }
        }
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .navigationTitle("Copilot Chat")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var modePicker: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text("Response mode")
                .font(Typography.micro.weight(.semibold))
                .foregroundStyle(Color.textSecondary)

            HStack(spacing: Spacing.xSmall) {
                ForEach(SupportDepthMode.allCases) { mode in
                    Button {
                        viewModel.setDepth(mode)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(mode.title)
                                .font(Typography.caption.weight(.semibold))
                            Text(mode.subtitle)
                                .font(Typography.micro)
                                .lineLimit(1)
                        }
                        .foregroundStyle(viewModel.supportDepth == mode ? Color.nightBackground : Color.textPrimary)
                        .padding(.horizontal, Spacing.small)
                        .padding(.vertical, Spacing.xSmall)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(viewModel.supportDepth == mode ? Color.secondaryAccent : Color.white.opacity(0.06))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.top, Spacing.medium)
        .padding(.bottom, Spacing.small)
    }

    private func messageBubble(_ message: AIChatMessage) -> some View {
        VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 6) {
            HStack(alignment: .bottom, spacing: Spacing.xSmall) {
                if message.role == .user { Spacer(minLength: 32) }

                if message.role != .user {
                    bubbleIcon(for: message.role)
                }

                Text(message.text)
                    .font(Typography.body)
                    .foregroundStyle(Color.textPrimary)
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

            if let handoff = message.handoff, message.role != .user {
                Button {
                    viewModel.performHandoff(handoff)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: handoff == .urgentHelp ? "phone.fill" : "bolt.fill")
                        Text(handoff.rawValue)
                            .font(Typography.caption.weight(.semibold))
                    }
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, Spacing.small)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(handoff == .urgentHelp ? Color.safetyAccent : Color.primaryAccent)
                    )
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isEscalated && handoff != .urgentHelp)
            }
        }
    }

    private var typingIndicator: some View {
        HStack {
            bubbleIcon(for: .assistant)

            Text("Listening…")
                .font(Typography.caption)
                .foregroundStyle(Color.textSecondary)
                .padding(.horizontal, Spacing.small)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.assistantBubble))

            Spacer()
        }
        .transition(.opacity)
    }

    private func bubbleIcon(for role: AIChatMessage.Role) -> some View {
        Image(systemName: role == .user ? "person.fill" : (role == .safety ? "exclamationmark.triangle.fill" : "sparkles"))
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 22, height: 22)
            .background(Circle().fill(backgroundColor(for: role).opacity(0.95)))
    }

    private var quickReplies: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xSmall) {
                ForEach(viewModel.quickReplies, id: \.self) { quickReply in
                    QuickActionChip(title: quickReply, subtitle: "Quick") {
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
            TextField("Tell Copilot what’s hardest right now…", text: $viewModel.inputText, axis: .vertical)
                .lineLimit(1...4)
                .font(Typography.body)
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )

            Button {
                Task { await viewModel.send() }
            } label: {
                Image(systemName: viewModel.isSending ? "hourglass" : "arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(Color.primaryAccent))
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isSending)
        }
        .padding(Spacing.medium)
    }

    private var escalationFooter: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text("Safety mode active")
                .font(Typography.caption.weight(.semibold))
                .foregroundStyle(Color.safetyAccent)
            Text("Normal chat is paused. Use urgent support options now.")
                .font(Typography.micro)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.medium)
        .background(Color.safetyBubble.opacity(0.5))
    }

    private func backgroundColor(for role: AIChatMessage.Role) -> Color {
        switch role {
        case .assistant:
            return Color.assistantBubble
        case .user:
            return Color.userBubble
        case .safety:
            return Color.safetyBubble.opacity(0.95)
        case .system:
            return Color.elevatedCardBackground
        }
    }
}

#Preview {
    NavigationStack {
        AIChatView(
            viewModel: AIChatViewModel(
                context: CopilotContext(nightState: .cantSwitchOff, currentPrompt: PromptLibrary.prompts.first)
            )
        )
    }
}
