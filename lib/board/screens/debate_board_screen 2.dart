import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/custom_theme.dart';

class DebateBoardScreen extends StatefulWidget {
  const DebateBoardScreen({super.key});

  @override
  State<DebateBoardScreen> createState() => _DebateBoardScreenState();
}

class _DebateBoardScreenState extends State<DebateBoardScreen> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 토론 주제 카드
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '10월 1주차 토론 주제',
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomTheme.neutral300,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: CustomTheme.neutral400,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '도리언 그레이의 초상화',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text(
                    '영원한 젊음을 위해\n영혼을 팔 수 있을까?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  child: Image.network(
                    'https://picsum.photos/400/250',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 선택 버튼
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selected = 'yes'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected == 'yes'
                            ? cs.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: selected == 'yes'
                          ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ]
                          : [],
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle_outlined,
                          color: selected == 'yes'
                              ? cs.primary
                              : CustomTheme.neutral300,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '그렇다',
                          style: TextStyle(
                            color: selected == 'yes'
                                ? cs.primary
                                : CustomTheme.neutral300,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selected = 'no'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected == 'no'
                            ? cs.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: selected == 'no'
                          ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ]
                          : [],
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          color: selected == 'no'
                              ? cs.primary
                              : CustomTheme.neutral300,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '아니다',
                          style: TextStyle(
                            color: selected == 'no'
                                ? cs.primary
                                : CustomTheme.neutral300,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}