import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_text_styles.dart';
import '../../core/design/app_radius.dart';

/// Checkout Screen - Pixel-perfect match to React version
/// Matches: components/screens/checkout-screen.tsx
class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic>? course;

  const CheckoutScreen({super.key, this.course});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPayment;
  String _couponCode = '';
  bool _couponApplied = false;
  bool _isProcessing = false;

  // Payment methods matching React exactly
  final _paymentMethods = [
    {
      'id': 'fawry',
      'name': 'فوري',
      'icon': Icons.account_balance,
      'description': 'ادفع في أي فرع فوري',
    },
    {
      'id': 'wallet',
      'name': 'محفظة إلكترونية',
      'icon': Icons.account_balance_wallet,
      'description': 'فودافون كاش - اتصالات كاش - أورانج كاش',
    },
    {
      'id': 'visa',
      'name': 'فيزا / ماستركارد',
      'icon': Icons.credit_card,
      'description': 'بطاقة ائتمان أو خصم',
    },
  ];

  double get _originalPrice => (widget.course?['price'] ?? 40.0) as double;
  double get _discount => _couponApplied ? _originalPrice * 0.2 : 0;
  double get _finalPrice => _originalPrice - _discount;

  void _handleApplyCoupon() {
    if (_couponCode.toLowerCase() == 'save20') {
      setState(() {
        _couponApplied = true;
      });
    }
  }

  void _handleCheckout() {
    if (_selectedPayment == null) return;
    setState(() {
      _isProcessing = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    if (course == null) {
      return Scaffold(
        backgroundColor: AppColors.beige,
        body: const Center(child: Text('لا توجد دورة')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header - matches React: bg-[var(--purple)] rounded-b-[3rem] pt-4 pb-8 px-4
            Container(
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.largeCard),
                  bottomRight: Radius.circular(AppRadius.largeCard),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16, // pt-4
                bottom: 32, // pb-8
                left: 16, // px-4
                right: 16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, // w-10
                      height: 40, // h-10
                      decoration: BoxDecoration(
                        color: AppColors.whiteOverlay20, // bg-white/20
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 20, // w-5 h-5
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // gap-4
                  Text(
                    'إتمام الشراء',
                    style: AppTextStyles.h3(color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content - matches React: px-4 -mt-4 space-y-4
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -16), // -mt-4
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // px-4
                  child: Column(
                    children: [
                      // Course Summary Card - matches React: bg-white rounded-3xl p-4 shadow-lg
                      Container(
                        margin: const EdgeInsets.only(bottom: 16), // space-y-4
                        padding: const EdgeInsets.all(16), // p-4
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24), // rounded-3xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Course image - matches React: w-20 h-20 rounded-2xl
                            Container(
                              width: 80, // w-20
                              height: 80, // h-20
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16), // rounded-2xl
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  course['image'] as String? ?? 'assets/images/motion-graphics-course-in-mumbai.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: AppColors.purple.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.image,
                                      color: AppColors.purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16), // gap-4
                            // Course info - matches React: flex-1
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['title'] as String? ?? 'عنوان الدورة',
                                    style: AppTextStyles.bodyMedium(
                                      color: AppColors.foreground,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4), // mb-1
                                  Text(
                                    course['instructor'] as String? ?? 'المدرب',
                                    style: AppTextStyles.bodySmall(
                                      color: AppColors.purple,
                                    ),
                                  ),
                                  const SizedBox(height: 8), // mb-2
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12, // w-3 h-3
                                        color: AppColors.orange,
                                      ),
                                      const SizedBox(width: 4), // gap-1
                                      Text(
                                        '${course['rating'] ?? 4.8}',
                                        style: AppTextStyles.labelSmall(
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                      const SizedBox(width: 12), // gap-3
                                      const Icon(
                                        Icons.access_time,
                                        size: 12, // w-3 h-3
                                        color: AppColors.mutedForeground,
                                      ),
                                      const SizedBox(width: 4), // gap-1
                                      Text(
                                        '${course['hours'] ?? 48}س',
                                        style: AppTextStyles.labelSmall(
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                      const SizedBox(width: 12), // gap-3
                                      const Icon(
                                        Icons.menu_book,
                                        size: 12, // w-3 h-3
                                        color: AppColors.mutedForeground,
                                      ),
                                      const SizedBox(width: 4), // gap-1
                                      Text(
                                        '${(course['lessons'] as List?)?.length ?? 22} درس',
                                        style: AppTextStyles.labelSmall(
                                          color: AppColors.mutedForeground,
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

                      // Coupon Section - matches React: bg-white rounded-2xl p-4 shadow-sm
                      Container(
                        margin: const EdgeInsets.only(bottom: 16), // space-y-4
                        padding: const EdgeInsets.all(16), // p-4
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16), // rounded-2xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_offer,
                                  size: 20, // w-5 h-5
                                  color: AppColors.purple,
                                ),
                                const SizedBox(width: 8), // gap-2
                                Text(
                                  'كوبون الخصم',
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.foreground,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12), // mb-3
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16, // px-4
                                      vertical: 12, // py-3
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lavenderLight,
                                      borderRadius: BorderRadius.circular(12), // rounded-xl
                                    ),
                                    child: TextField(
                                      enabled: !_couponApplied,
                                      decoration: const InputDecoration(
                                        hintText: 'أدخل كود الخصم',
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                      style: AppTextStyles.bodyMedium(
                                        color: AppColors.foreground,
                                      ),
                                      onChanged: (value) {
                                        _couponCode = value;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8), // gap-2
                                GestureDetector(
                                  onTap: _couponApplied || _couponCode.isEmpty
                                      ? null
                                      : _handleApplyCoupon,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24, // px-6
                                      vertical: 12, // py-3
                                    ),
                                    decoration: BoxDecoration(
                                      color: _couponApplied
                                          ? Colors.green[100]
                                          : AppColors.purple,
                                      borderRadius: BorderRadius.circular(12), // rounded-xl
                                    ),
                                    child: _couponApplied
                                        ? Icon(
                                            Icons.check,
                                            size: 20, // w-5 h-5
                                            color: Colors.green[600],
                                          )
                                        : Text(
                                            'تطبيق',
                                            style: AppTextStyles.bodyMedium(
                                              color: Colors.white,
                                            ).copyWith(fontWeight: FontWeight.w500),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            if (_couponApplied) ...[
                              const SizedBox(height: 8), // mt-2
                              Text(
                                'تم تطبيق الخصم 20%',
                                style: AppTextStyles.bodySmall(
                                  color: Colors.green[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Payment Methods - matches React: bg-white rounded-2xl p-4 shadow-sm
                      Container(
                        margin: const EdgeInsets.only(bottom: 16), // space-y-4
                        padding: const EdgeInsets.all(16), // p-4
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16), // rounded-2xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16), // mb-4
                              child: Text(
                                'طريقة الدفع',
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.foreground,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ..._paymentMethods.map((method) {
                              final isSelected = _selectedPayment == method['id'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPayment = method['id'] as String;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12), // space-y-3
                                  padding: const EdgeInsets.all(16), // p-4
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.lavenderLight
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.purple
                                          : Colors.grey[200]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16), // rounded-2xl
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48, // w-12
                                        height: 48, // h-12
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.purple
                                              : Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12), // rounded-xl
                                        ),
                                        child: Icon(
                                          method['icon'] as IconData,
                                          size: 24, // w-6 h-6
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[500],
                                        ),
                                      ),
                                      const SizedBox(width: 16), // gap-4
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              method['name'] as String,
                                              style: AppTextStyles.bodyMedium(
                                                color: AppColors.foreground,
                                              ).copyWith(fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              method['description'] as String,
                                              style: AppTextStyles.labelSmall(
                                                color: AppColors.mutedForeground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 24, // w-6
                                        height: 24, // h-6
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? AppColors.purple
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.purple
                                                : Colors.grey[300]!,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                size: 16, // w-4 h-4
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      // Price Summary - matches React: bg-white rounded-2xl p-4 shadow-sm
                      Container(
                        margin: const EdgeInsets.only(bottom: 16), // space-y-4
                        padding: const EdgeInsets.all(16), // p-4
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16), // rounded-2xl
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16), // mb-4
                              child: Text(
                                'ملخص الطلب',
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.foreground,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Price rows - matches React: space-y-3
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'سعر الدورة',
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                Text(
                                  '${_originalPrice.toStringAsFixed(0)} جنيه',
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.foreground,
                                  ).copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            if (_couponApplied) ...[
                              const SizedBox(height: 12), // space-y-3
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الخصم (20%)',
                                    style: AppTextStyles.bodyMedium(
                                      color: Colors.green[600],
                                    ),
                                  ),
                                  Text(
                                    '-${_discount.toStringAsFixed(2)} جنيه',
                                    style: AppTextStyles.bodyMedium(
                                      color: Colors.green[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            Container(
                              height: 1,
                              color: Colors.grey[100],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الإجمالي',
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.foreground,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${_finalPrice.toStringAsFixed(2)} جنيه',
                                  style: AppTextStyles.h2(
                                    color: AppColors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Checkout Button - matches React
                      GestureDetector(
                        onTap: _selectedPayment == null || _isProcessing
                            ? null
                            : _handleCheckout,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16), // py-4
                          decoration: BoxDecoration(
                            color: _selectedPayment != null && !_isProcessing
                                ? AppColors.purple
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16), // rounded-2xl
                          ),
                          child: Center(
                            child: Text(
                              _isProcessing ? 'جاري المعالجة...' : 'تأكيد الدفع',
                              style: AppTextStyles.buttonLarge(
                                color: _selectedPayment != null && !_isProcessing
                                    ? Colors.white
                                    : Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
