import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/mock_api/currency.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../bottom_sheets/singleAccountSheet.dart';
import '../../bottom_sheets/multipleAccountsSheet.dart';
import 'transfer_state.dart';

enum _PickerMode { search, recents, contacts }

/// Data the picker needs to carry forward once a recipient is chosen,
/// since selecting a recipient now skips back through PaySheet
/// entirely and opens the next sheet directly.
class RecipientPickerArgs {
  final String amount;
  final AmountCurrency currency;
  final String memo;
  final ValueChanged<String> onMemoChanged;

  const RecipientPickerArgs({
    required this.amount,
    required this.currency,
    required this.memo,
    required this.onMemoChanged,
  });
}

/// "New Transfa" recipient picker. Three modes selected by the bottom
/// segmented control: search results, Recents tab, Contacts tab.
///
/// Picking a recipient here no longer pops a result back to PaySheet.
/// It closes itself *and* the PaySheet bottom sheet underneath it,
/// then opens SingleAccountSheet or MultipleAccountsSheet directly —
/// so the user goes straight from "who" to "confirm the details."
class RecipientPickerScreen extends ConsumerStatefulWidget {
  final RecipientPickerArgs args;
  const RecipientPickerScreen({super.key, required this.args});

  @override
  ConsumerState<RecipientPickerScreen> createState() =>
      _RecipientPickerScreenState();
}

class _RecipientPickerScreenState extends ConsumerState<RecipientPickerScreen> {
  _PickerMode _mode = _PickerMode.recents;
  final _search = TextEditingController();
  String? _selectedContactName;

  static final Map<String, String> _accountNumbers = {
    'Amadioha Obi': '123 456 7890',
    'Dalia Wetzel': '234 567 8901',
    'Magic Payma': '207 922 3313',
    'Hugo Menendez': '345 678 9012',
    'Saraphina Gonzalez': '456 789 0123',
    'Sarah Bon': '567 890 1234',
    'Janelle Hickleson': '678 901 2345',
    'John Caled': '789 012 3456',
    'Tobias Walsh': '890 123 4567',
    'Maya Carter': '901 234 5678',
  };

  // Mock bank list used when a recipient has multiple accounts on file.
  static const List<BankAccount> _mockBanks = [
    BankAccount(
      name: 'Transfa',
      logoAsset: Assets.logoSmallWhite,
      gradientColor1: Color(0xFF000000),
      gradientColor2: Color(0xFF000000),
    ),
    BankAccount(
      name: 'FCMB',
      logoAsset: Assets.bankfcmbRound,
      gradientColor1: Color(0xFF5C2684),
      gradientColor2: Color(0xFF5C2684),
    ),
    BankAccount(
      name: 'OPay',
      logoAsset: Assets.bankOpay,
      gradientColor1: Color(0xFFFFFFFF),
      gradientColor2: Color(0xFFFFFFFF),
    ),
  ];

  // Mock flag — every recipient resolves to the multi-bank flow here,
  // matching the previous PaySheet behavior. Swap in real account-count
  // data when it's available.
  static const bool _mockHasMultipleBanks = true;

  static final _contacts = [
    _Contact('Amadioha Obi', null, color: Color(0xFFFF375F), red: true),
    _Contact('Dalia Wetzel', Assets.avatarGrace),
    _Contact('Magic Payma', Assets.magic),
    _Contact('Hugo Menendez', null, color: Color(0xFFD9D9D9)),
    _Contact('Saraphina Gonzalez', null, color: Color(0xFFC9826B)),
  ];

  static final _contactsMore = [
    _Contact('Sarah Bon', Assets.avatarSarah),
    _Contact('Janelle Hickleson', Assets.avatarJanelle),
    _Contact('John Caled', null, color: Color(0xFF34C759)),
    _Contact('Tobias Walsh', null, color: Color(0xFF6238FB)),
    _Contact('Maya Carter', null, color: Color(0xFFFF9F0A)),
  ];

  static final _recents = [
    _Contact('Magic Payma', Assets.magic, subtitle: 'Yesterday', sentUp: true),
    _Contact(
      'Spotify',
      null,
      color: Color(0xFF1ED760),
      subtitle: '12 minutes ago',
      sentUp: true,
      spotify: true,
    ),
    _Contact(
      'Dalia Wetzel',
      Assets.avatarGrace,
      subtitle: 'Thursday',
      sentUp: false,
    ),
    _Contact(
      'Amadioha Obi',
      null,
      color: Color(0xFFFF375F),
      red: true,
      subtitle: '2 days ago',
      sentUp: false,
    ),
    _Contact(
      'Sarah Bon',
      Assets.avatarSarah,
      subtitle: '5 days ago',
      sentUp: true,
    ),
  ];

  static final _recentsOlder = [
    _Contact(
      'Janelle Hickleson',
      Assets.avatarJanelle,
      subtitle: '1 week ago',
      sentUp: false,
    ),
    _Contact(
      'Hugo Menendez',
      null,
      color: Color(0xFF6238FB),
      subtitle: '2 weeks ago',
      sentUp: true,
    ),
    _Contact(
      'Saraphina Gonzalez',
      null,
      color: Color(0xFFC9826B),
      subtitle: '3 weeks ago',
      sentUp: true,
    ),
    _Contact(
      'Amadioha Obi',
      null,
      color: Color(0xFFFF375F),
      red: true,
      subtitle: '1 month ago',
      sentUp: false,
    ),
    _Contact(
      'Magic Payma',
      Assets.magic,
      subtitle: '2 months ago',
      sentUp: true,
    ),
  ];

  void _pick(_Contact c) {
    final accountNumber = _accountNumbers[c.name] ?? '000 000 0000';
    final recipientImage = c.asset ?? Assets.magic;

    ref.read(transferDraftProvider.notifier).state = ref
        .read(transferDraftProvider)
        .copyWith(recipientName: c.name);

    // Capture the Navigator before popping — its own context stays
    // valid even after the routes stacked on it are removed, so we
    // can safely use it to open the next sheet right after.
    final navigator = Navigator.of(context);
    navigator.pop(); // close the recipient picker
    navigator.pop(); // close the PaySheet bottom sheet underneath it
    if (!navigator.mounted) return;

    final args = widget.args;

    showModalBottomSheet(
      context: navigator.context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      builder: (_) => _mockHasMultipleBanks
          ? MultipleAccountsSheet(
              recipientName: c.name,
              currency: args.currency,
              amount: args.amount,
              memo: args.memo,
              recipientImageUrl: recipientImage,
              accountNumber: accountNumber,
              banks: _mockBanks,
              onMemoChanged: args.onMemoChanged,
            )
          : SingleAccountSheet(
              recipientName: c.name,
              currencySymbol: args.currency.symbol,
              amount: args.amount,
              memo: args.memo,
              accountNumber: accountNumber,
              bankName: 'OPay',
              bankLogoAsset: Assets.bankOpay,
              recipientImageUrl: recipientImage,
              onMemoChanged: args.onMemoChanged,
            ),
    );
  }

  void _selectContact(String name) {
    setState(() {
      _selectedContactName = _selectedContactName == name ? null : name;
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _mode == _PickerMode.search
        ? 'Find a contact or account.'
        : 'Who do you want to pay?';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              children: [
                _HeaderCard(subtitle: subtitle),
                const SizedBox(height: 48),
                if (_mode == _PickerMode.search) ..._searchView(),
                if (_mode == _PickerMode.recents)
                  ..._sectionView(
                    icon: const _RecentsCircle(),
                    label: 'Recents',
                    items: _recents,
                    extraItems: _recentsOlder,
                  ),
                if (_mode == _PickerMode.contacts)
                  ..._sectionView(
                    icon: const _ContactsCircle(),
                    label: 'Contacts',
                    items: _contacts,
                    extraItems: _contactsMore,
                  ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: _BottomBar(
                mode: _mode,
                search: _search,
                onModeChanged: (m) => setState(() => _mode = m),
                onClose: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _sectionView({
    required Widget icon,
    required String label,
    required List<_Contact> items,
    List<_Contact>? extraItems,
  }) {
    return [
      Row(
        children: [
          icon,
          const SizedBox(width: 14),
          Text(
            label,
            style: AppTypography.displayMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      _ListCard(
        children: items
            .map(
              (c) => _ContactRow(
                contact: c,
                isSelected: _selectedContactName == c.name,
                onTap: () {
                  _selectContact(c.name);
                  _pick(c);
                },
              ),
            )
            .toList(),
      ),
      if (extraItems != null) ...[
        const SizedBox(height: 18),
        _ListCard(
          children: extraItems
              .map(
                (c) => _ContactRow(
                  contact: c,
                  isSelected: _selectedContactName == c.name,
                  onTap: () {
                    _selectContact(c.name);
                    _pick(c);
                  },
                ),
              )
              .toList(),
        ),
      ],
    ];
  }

  List<Widget> _searchView() {
    final top = [
      _Contact('Amadioha Obi', null, color: Color(0xFFFF375F), red: true),
    ];
    final others = [
      _Contact('Magic Payma', Assets.magic),
      _Contact('Sarah Bon', Assets.avatarSarah),
      _Contact('Dalia Wetzel', Assets.avatarGrace),
    ];
    return [
      Text(
        'Top Result',
        style: AppTypography.displayMedium.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 12),
      _ListCard(
        children: top
            .map(
              (c) => _ContactRow(
                contact: c,
                isSelected: _selectedContactName == c.name,
                onTap: () {
                  _selectContact(c.name);
                  _pick(c);
                },
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 28),
      Text(
        'Others',
        style: AppTypography.displayMedium.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 12),
      _ListCard(
        children: others
            .map(
              (c) => _ContactRow(
                contact: c,
                isSelected: _selectedContactName == c.name,
                onTap: () {
                  _selectContact(c.name);
                  _pick(c);
                },
              ),
            )
            .toList(),
      ),
    ];
  }
}

class _Contact {
  final String name;
  final String? asset;
  final Color? color;
  final bool red;
  final bool spotify;
  final String? subtitle;
  final bool sentUp;
  const _Contact(
    this.name,
    this.asset, {
    this.color,
    this.red = false,
    this.spotify = false,
    this.subtitle,
    this.sentUp = true,
  });
}

class _HeaderCard extends StatelessWidget {
  final String subtitle;
  const _HeaderCard({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      radius: 28,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const TransfaMark(size: 30, white: true),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Transfa',
                  style: AppTypography.displayMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final List<Widget> children;
  const _ListCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(children: children),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final _Contact contact;
  final bool isSelected;
  final VoidCallback onTap;
  const _ContactRow({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = _avatar();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            SizedBox(width: 52, height: 52, child: avatar),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: AppTypography.subheading.copyWith(fontSize: 17),
                  ),
                  if (contact.subtitle != null)
                    Row(
                      children: [
                        Icon(
                          contact.sentUp
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contact.subtitle!,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    if (contact.spotify) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1ED760),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/icons/logos_spotify-icon.svg',
          fit: BoxFit.contain,
        ),
      );
    }
    if (contact.asset != null) {
      return ClipOval(child: Image.asset(contact.asset!, fit: BoxFit.cover));
    }
    return Container(
      decoration: BoxDecoration(
        color: contact.color ?? const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
    );
  }
}

class _RecentsCircle extends StatelessWidget {
  const _RecentsCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SvgPicture.asset(Assets.recents, fit: BoxFit.cover),
      ),
    );
  }
}

class _ContactsCircle extends StatelessWidget {
  const _ContactsCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      child: SvgPicture.asset(Assets.contactHeader, width: 56, height: 56),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final _PickerMode mode;
  final TextEditingController search;
  final ValueChanged<_PickerMode> onModeChanged;
  final VoidCallback onClose;

  const _BottomBar({
    required this.mode,
    required this.search,
    required this.onModeChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (mode == _PickerMode.search) {
      return Row(
        children: [
          _RoundIcon(
            child: SvgPicture.asset(Assets.contactsDark, width: 35, height: 35),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SearchPill(
              controller: search,
              onClear: () => search.clear(),
            ),
          ),
          const SizedBox(width: 8),
          _RoundIcon(
            onTap: onClose,
            child: const Icon(
              Icons.close_rounded,
              color: Colors.black,
              size: 22,
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        _RoundIcon(
          onTap: () => onModeChanged(_PickerMode.search),
          child: const Icon(
            Icons.search_rounded,
            color: Colors.black,
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    icon: Icons.access_time_filled_rounded,
                    label: 'Recents',
                    active: mode == _PickerMode.recents,
                    activeColor: const Color(0xFFFF9F0A),
                    onTap: () => onModeChanged(_PickerMode.recents),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    icon: Icons.person_rounded,
                    label: 'Contacts',
                    active: mode == _PickerMode.contacts,
                    activeColor: const Color(0xFFFF375F),
                    onTap: () => onModeChanged(_PickerMode.contacts),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _RoundIcon(
          onTap: onClose,
          child: const Icon(Icons.close_rounded, color: Colors.black, size: 22),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;
  const _TabButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : Colors.black87;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  const _SearchPill({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search_rounded, color: Colors.black54, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                hintText: '',
                border: InputBorder.none,
                isDense: true,
              ),
              style: AppTypography.subheading.copyWith(fontSize: 20),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black,
              child: Icon(Icons.close_rounded, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _RoundIcon({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
