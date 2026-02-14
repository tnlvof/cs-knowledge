"use client";

import { Suspense, useState, useEffect, useCallback } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";
import Modal from "@/components/ui/Modal";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import { useAuth } from "@/hooks/use-auth";
import { SUPPORTER_TIERS } from "@/constants/supporters";

interface GemPackage {
  amount: number;
  gems: number;
  bonus: string;
  popular?: boolean;
}

const GEM_PACKAGES: GemPackage[] = [
  { amount: 1000, gems: 100, bonus: "" },
  { amount: 3000, gems: 330, bonus: "+10%" },
  { amount: 5000, gems: 575, bonus: "+15%", popular: true },
  { amount: 10000, gems: 1200, bonus: "+20%" },
];

export default function DonatePage() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <DonateContent />
    </Suspense>
  );
}

function DonateContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { isAuthenticated, isLoading: authLoading } = useAuth();
  const [selectedPackage, setSelectedPackage] = useState<GemPackage | null>(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const [gemBalance, setGemBalance] = useState(0);
  const [totalDonated, setTotalDonated] = useState(0);
  const [supporterTier, setSupporterTier] = useState("none");
  const [showSuccessModal, setShowSuccessModal] = useState(false);
  const [purchaseResult, setPurchaseResult] = useState<{ gems: number; tier: string } | null>(null);
  const [toast, setToast] = useState<string | null>(null);

  const showToast = (message: string) => {
    setToast(message);
    setTimeout(() => setToast(null), 3000);
  };

  const fetchProfile = useCallback(async () => {
    if (!isAuthenticated) return;

    try {
      const response = await fetch("/api/game/profile");
      const data = await response.json();
      if (response.ok) {
        setGemBalance(data.profile.gemBalance);
        setTotalDonated(data.profile.totalDonated);
        setSupporterTier(data.profile.supporterTier);
      }
    } catch (error) {
      console.error("Failed to fetch profile:", error);
    }
  }, [isAuthenticated]);

  useEffect(() => {
    if (!authLoading) {
      fetchProfile();
    }
  }, [authLoading, fetchProfile]);

  // Handle payment callback
  useEffect(() => {
    const paymentKey = searchParams.get("paymentKey");
    const orderId = searchParams.get("orderId");
    const amount = searchParams.get("amount");

    if (paymentKey && orderId && amount) {
      confirmPayment(paymentKey, orderId, parseInt(amount, 10)).catch(console.error);
    }
  }, [searchParams]);

  const confirmPayment = async (paymentKey: string, orderId: string, amount: number) => {
    setIsProcessing(true);
    try {
      const response = await fetch("/api/payment/confirm", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ paymentKey, orderId, amount }),
      });

      const data = await response.json();

      if (response.ok) {
        setPurchaseResult({ gems: data.gemAmount, tier: data.supporterTier });
        setGemBalance(data.newGemBalance);
        setSupporterTier(data.supporterTier);
        setShowSuccessModal(true);
        // Clear URL params
        router.replace("/donate");
      } else {
        showToast(data.error || "결제 확인에 실패했습니다");
      }
    } catch (error) {
      console.error("Payment confirm error:", error);
      showToast("결제 확인 중 오류가 발생했습니다");
    } finally {
      setIsProcessing(false);
    }
  };

  const handlePurchase = async () => {
    if (!selectedPackage || !isAuthenticated) return;

    setIsProcessing(true);
    try {
      const response = await fetch("/api/payment/ready", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ amount: selectedPackage.amount }),
      });

      const data = await response.json();

      if (response.ok) {
        // TossPayments SDK integration would go here
        // For now, simulate with a mock
        const tossPayments = (window as any).TossPayments;
        if (tossPayments) {
          const payment = tossPayments(process.env.NEXT_PUBLIC_TOSS_CLIENT_KEY);
          await payment.requestPayment("카드", {
            amount: data.amount,
            orderId: data.orderId,
            orderName: data.orderName,
            customerName: data.customerName,
            customerEmail: data.customerEmail,
            successUrl: `${window.location.origin}/donate?success=true`,
            failUrl: `${window.location.origin}/donate?fail=true`,
          });
        } else {
          // Fallback for development without TossPayments SDK
          showToast("TossPayments SDK가 로드되지 않았습니다. 개발 환경에서는 결제를 진행할 수 없습니다.");
        }
      } else {
        showToast(data.error || "결제 준비에 실패했습니다");
      }
    } catch (error) {
      console.error("Purchase error:", error);
      showToast("결제 중 오류가 발생했습니다");
    } finally {
      setIsProcessing(false);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat("ko-KR").format(amount);
  };

  const getNextTier = () => {
    const sortedTiers = [...SUPPORTER_TIERS].sort((a, b) => a.minAmount - b.minAmount);
    for (const tier of sortedTiers) {
      if (totalDonated < tier.minAmount) {
        return { ...tier, remaining: tier.minAmount - totalDonated };
      }
    }
    return null;
  };

  const nextTier = getNextTier();

  if (authLoading) {
    return <LoadingSpinner />;
  }

  return (
    <div className="flex min-h-dvh flex-col px-4 pb-safe-bottom pt-6">
      {/* Header */}
      <div className="mb-4 flex items-center justify-between">
        <button
          onClick={() => router.back()}
          className="flex h-10 w-10 items-center justify-center rounded-full hover:bg-maple-cream/50"
          aria-label="뒤로 가기"
        >
          <span className="text-xl" aria-hidden="true">&larr;</span>
        </button>
        <h1 className="font-pixel text-lg">젬 충전</h1>
        <div className="flex items-center gap-1 rounded-lg bg-amber-100 px-3 py-1">
          <span className="text-lg">💎</span>
          <span className="font-pixel text-sm tabular-nums text-amber-700">{gemBalance}</span>
        </div>
      </div>

      {!isAuthenticated && (
        <Card className="mb-4 bg-amber-50">
          <p className="text-sm text-amber-700">
            로그인 후 젬을 충전할 수 있습니다
          </p>
        </Card>
      )}

      {/* Supporter Progress */}
      {isAuthenticated && (
        <Card className="mb-4">
          <div className="flex items-center justify-between mb-2">
            <span className="text-sm text-text-secondary">후원 등급</span>
            <span className="flex items-center gap-1">
              {supporterTier !== "none" && (
                <>
                  <span>
                    {SUPPORTER_TIERS.find((t) => t.tier === supporterTier)?.emoji}
                  </span>
                  <span className={SUPPORTER_TIERS.find((t) => t.tier === supporterTier)?.color}>
                    {SUPPORTER_TIERS.find((t) => t.tier === supporterTier)?.name}
                  </span>
                </>
              )}
              {supporterTier === "none" && (
                <span className="text-text-muted">일반</span>
              )}
            </span>
          </div>
          <p className="text-xs text-text-muted mb-2">
            총 후원: {formatCurrency(totalDonated)}원
          </p>
          {nextTier && (
            <div className="space-y-1">
              <div className="flex items-center justify-between text-xs">
                <span>다음 등급: {nextTier.emoji} {nextTier.name}</span>
                <span>{formatCurrency(nextTier.remaining)}원 남음</span>
              </div>
              <div className="h-2 w-full overflow-hidden rounded-full bg-gray-200">
                <motion.div
                  className="h-full bg-gradient-to-r from-amber-400 to-amber-600"
                  initial={{ width: 0 }}
                  animate={{
                    width: `${Math.min(100, (totalDonated / nextTier.minAmount) * 100)}%`,
                  }}
                />
              </div>
            </div>
          )}
        </Card>
      )}

      {/* Gem Packages */}
      <div className="flex-1 space-y-3">
        <h2 className="font-pixel text-sm text-text-secondary">젬 패키지</h2>
        {GEM_PACKAGES.map((pkg, index) => (
          <motion.div
            key={pkg.amount}
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: index * 0.1 }}
          >
            <button
              onClick={() => setSelectedPackage(pkg)}
              disabled={!isAuthenticated}
              className={`w-full rounded-2xl border-2 p-4 text-left transition-all ${
                selectedPackage?.amount === pkg.amount
                  ? "border-accent-orange bg-orange-50"
                  : "border-maple-medium bg-frame hover:border-amber-300"
              } ${!isAuthenticated ? "opacity-60" : ""}`}
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-amber-400 to-amber-600 text-2xl">
                    💎
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-pixel text-lg">{pkg.gems} 젬</span>
                      {pkg.bonus && (
                        <span className="rounded-full bg-green-100 px-2 py-0.5 text-xs text-green-700">
                          {pkg.bonus}
                        </span>
                      )}
                      {pkg.popular && (
                        <span className="rounded-full bg-accent-orange px-2 py-0.5 text-xs text-white">
                          인기
                        </span>
                      )}
                    </div>
                    <span className="text-sm text-text-secondary">
                      {formatCurrency(pkg.amount)}원
                    </span>
                  </div>
                </div>
                <div
                  className={`h-6 w-6 rounded-full border-2 ${
                    selectedPackage?.amount === pkg.amount
                      ? "border-accent-orange bg-accent-orange"
                      : "border-gray-300"
                  }`}
                >
                  {selectedPackage?.amount === pkg.amount && (
                    <span className="flex h-full w-full items-center justify-center text-white text-xs">
                      ✓
                    </span>
                  )}
                </div>
              </div>
            </button>
          </motion.div>
        ))}
      </div>

      {/* Supporter Benefits */}
      <Card className="mt-4 bg-gradient-to-r from-amber-50 to-orange-50">
        <h3 className="font-pixel text-sm mb-2">후원자 혜택</h3>
        <ul className="space-y-1 text-xs text-text-secondary">
          <li>🥉 브론즈: 프로필 뱃지, 전용 프레임</li>
          <li>🥈 실버: + 매월 50젬 지급</li>
          <li>🥇 골드: + 전용 이펙트, 우선 CS 질문 답변</li>
        </ul>
      </Card>

      {/* Purchase Button */}
      <div className="mt-4 pb-4">
        <Button
          variant="primary"
          size="lg"
          className="w-full"
          disabled={!selectedPackage || !isAuthenticated || isProcessing}
          loading={isProcessing}
          onClick={handlePurchase}
        >
          {selectedPackage
            ? `${formatCurrency(selectedPackage.amount)}원 결제하기`
            : "패키지를 선택하세요"}
        </Button>
        <p className="mt-2 text-center text-xs text-text-muted">
          결제는 토스페이먼츠를 통해 안전하게 처리됩니다
        </p>
      </div>

      {/* Success Modal */}
      <Modal
        isOpen={showSuccessModal}
        onClose={() => setShowSuccessModal(false)}
        title="충전 완료!"
      >
        <div className="space-y-4 text-center">
          <div className="text-6xl">🎉</div>
          <p className="font-pixel text-lg">
            {purchaseResult?.gems}젬이 지급되었습니다!
          </p>
          {purchaseResult?.tier && purchaseResult.tier !== "none" && (
            <p className="text-sm text-text-secondary">
              {SUPPORTER_TIERS.find((t) => t.tier === purchaseResult.tier)?.emoji}{" "}
              {SUPPORTER_TIERS.find((t) => t.tier === purchaseResult.tier)?.name} 등급 달성!
            </p>
          )}
          <Button
            variant="primary"
            size="md"
            className="w-full"
            onClick={() => setShowSuccessModal(false)}
          >
            확인
          </Button>
        </div>
      </Modal>

      {toast && (
        <div className="fixed bottom-20 left-4 right-4 z-50 animate-bounce-in">
          <div className="rounded-xl bg-gray-800 px-4 py-3 text-center text-sm text-white shadow-lg">
            {toast}
            <button onClick={() => setToast(null)} className="ml-2 text-gray-400" aria-label="닫기">✕</button>
          </div>
        </div>
      )}
    </div>
  );
}
