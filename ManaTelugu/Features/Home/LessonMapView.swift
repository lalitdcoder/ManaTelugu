import SwiftUI

// MARK: - Topic Model

struct LessonTopic: Identifiable {
    let id: String
    let title: String
    let emoji: String
    let icon: String
    let tiers: [LessonTierNode]
}

struct LessonTierNode: Identifiable {
    let id: String          // e.g. "Animals_1"
    let topic: String
    let tier: Int           // 1 = Bronze, 2 = Silver, 3 = Gold
    let tierName: String
    let color: Color
    let xpReward: Int
}

// MARK: - Map Node State

enum MapNodeState {
    case locked
    case unlocked
    case completed
}

// MARK: - LessonMapView (Phase 2)

struct LessonMapView: View {
    @EnvironmentObject var session: AppSession
    @ObservedObject var progressTracker: ProgressTracker = .shared

    /// Flat list of every node in the S-Curve; order determines the path
    private let allNodes: [LessonTierNode] = LessonMapView.buildNodes()

    @State private var selectedNode: LessonTierNode? = nil
    @State private var showingLesson: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        ModernDesignSystem.Colors.primary.opacity(0.15),
                        ModernDesignSystem.Colors.secondary.opacity(0.08),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        // Decorative header
                        headerView
                            .padding(.bottom, 32)

                        // S-Curve path of nodes
                        ForEach(Array(allNodes.enumerated()), id: \.element.id) { index, node in
                            let state = nodeState(for: index)

                            MapNodeView(
                                node: node,
                                levelNumber: index + 1,
                                state: state
                            )
                            .offset(x: xOffset(for: index))
                            .padding(.vertical, 8)
                            .onTapGesture {
                                if state != .locked {
                                    HapticsManager.shared.impact(.medium)
                                    selectedNode = node
                                    showingLesson = true
                                } else {
                                    HapticsManager.shared.trigger(.warning)
                                }
                            }
                        }

                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Learning Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showingLesson) {
                if let node = selectedNode {
                    DynamicLessonFlowView(node: node)
                        .environmentObject(session)
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("🏆 Your Journey")
                .font(ModernDesignSystem.Typography.title1)
                .fontWeight(.bold)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)

            HStack(spacing: 20) {
                statPill(icon: "star.fill", color: .yellow, value: "\(session.totalXP) XP")
                statPill(icon: "flame.fill", color: .orange, value: "\(session.currentStreak) days")
                statPill(
                    icon: "checkmark.seal.fill", color: .green,
                    value: "\(progressTracker.maxCompletedLevelIndex + 1) done")
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: ModernDesignSystem.CornerRadius.xl)
                .fill(.ultraThinMaterial)
                .shadow(color: ModernDesignSystem.Colors.shadow, radius: 12, x: 0, y: 6)
        )
    }

    private func statPill(icon: String, color: Color, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text(value)
                .font(ModernDesignSystem.Typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(ModernDesignSystem.Colors.textPrimary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(ModernDesignSystem.Colors.surface.opacity(0.9))
        .clipShape(Capsule())
    }

    // MARK: - S-Curve Math

    /// Winding offset pattern:  center → right → center → left → repeat
    private func xOffset(for index: Int) -> CGFloat {
        switch index % 4 {
        case 0: return 0
        case 1: return 65
        case 2: return 0
        case 3: return -65
        default: return 0
        }
    }

    // MARK: - Node State Logic

    private func nodeState(for index: Int) -> MapNodeState {
        if index <= progressTracker.maxCompletedLevelIndex {
            return .completed
        } else if index == progressTracker.maxCompletedLevelIndex + 1 {
            return .unlocked   // next in line is always unlocked
        } else {
            return .locked
        }
    }

    // MARK: - Static Node Construction

    static func buildNodes() -> [LessonTierNode] {
        let topics: [(topic: String, emoji: String)] = [
            ("Animals", "🐘"),
            ("Family", "👨‍👩‍👧"),
            ("Colors", "🎨"),
            ("Food", "🍛"),
            ("Numbers", "🔢"),
            ("Body Parts", "🫀"),
            ("Nature", "🌿"),
            ("Greetings", "🙏"),
            ("Weather", "🌦"),
            ("Daily Actions", "📅"),
            ("School Objects", "📚"),
            ("Time", "⏰"),
        ]

        var nodes: [LessonTierNode] = []

        for (topic, emoji) in topics {
            for tier in 1...3 {
                let tierName: String
                let color: Color
                let xp: Int

                switch tier {
                case 1:
                    tierName = "Bronze"
                    color = Color(red: 0.80, green: 0.50, blue: 0.20)
                    xp = 50
                case 2:
                    tierName = "Silver"
                    color = Color(red: 0.55, green: 0.60, blue: 0.70)
                    xp = 100
                default:
                    tierName = "Gold"
                    color = Color(red: 0.90, green: 0.75, blue: 0.10)
                    xp = 150
                }

                nodes.append(
                    LessonTierNode(
                        id: "\(topic)_\(tier)",
                        topic: topic,
                        tier: tier,
                        tierName: "\(emoji) \(topic) · \(tierName)",
                        color: color,
                        xpReward: xp
                    ))
            }
        }

        return nodes
    }
}

// MARK: - MapNodeView

struct MapNodeView: View {
    let node: LessonTierNode
    let levelNumber: Int
    let state: MapNodeState

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Outer glow ring for unlocked
                if state == .unlocked {
                    Circle()
                        .stroke(node.color.opacity(0.4), lineWidth: 6)
                        .frame(width: 96, height: 96)
                        .scaleEffect(isAnimating ? 1.15 : 1.0)
                        .opacity(isAnimating ? 0.0 : 0.6)
                        .animation(
                            .easeOut(duration: 1.4).repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }

                // Main circle button
                Circle()
                    .fill(circleFill)
                    .frame(width: 80, height: 80)
                    .shadow(
                        color: state == .locked ? .clear : node.color.opacity(0.5),
                        radius: 10, x: 0, y: 5
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                state == .completed
                                    ? Color.white.opacity(0.5) : Color.clear, lineWidth: 3)
                    )

                // Icon/Label
                if state == .locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                } else if state == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(levelNumber)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 100, height: 100)

            // Label beneath node
            Text(node.tierName)
                .font(ModernDesignSystem.Typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(
                    state == .locked
                        ? ModernDesignSystem.Colors.textTertiary
                        : ModernDesignSystem.Colors.textPrimary
                )
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: 140)

            // XP badge
            if state != .locked {
                Text("+\(node.xpReward) XP")
                    .font(ModernDesignSystem.Typography.caption2)
                    .foregroundColor(node.color)
                    .fontWeight(.medium)
            }
        }
        .onAppear {
            if state == .unlocked {
                isAnimating = true
            }
        }
        .onChange(of: state) { _, newState in
            isAnimating = (newState == .unlocked)
        }
        .opacity(state == .locked ? 0.55 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: state)
    }

    private var circleFill: AnyShapeStyle {
        switch state {
        case .locked:
            return AnyShapeStyle(Color.gray.opacity(0.4))
        case .unlocked:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [node.color, node.color.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        case .completed:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [ModernDesignSystem.Colors.success, Color.green.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        }
    }
}
