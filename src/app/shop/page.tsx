"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";
import Modal from "@/components/ui/Modal";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import { useAuth } from "@/hooks/use-auth";
import type { ShopItem, ItemCategory, ItemRarity } from "@/types/game";

const ITEM_CATEGORIES: { id: ItemCategory | "all"; name: string; emoji: string }[] = [
  { id: "all", name: "전체", emoji: "🛒" },
  { id: "hat", name: "모자", emoji: "🎩" },
  { id: "weapon_skin", name: "무기", emoji: "⚔️" },
  { id: "costume", name: "의상", emoji: "👔" },
  { id: "effect", name: "이펙트", emoji: "✨" },
  { id: "pet", name: "펫", emoji: "🐾" },
  { id: "frame", name: "프레임", emoji: "🖼️" },
];

const RARITY_COLORS: Record<ItemRarity, string> = {
  common: "border-gray-300 bg-gray-50",
  rare: "border-blue-400 bg-blue-50",
  epic: "border-purple-400 bg-purple-50",
  legendary: "border-amber-400 bg-amber-50",
};

const RARITY_LABELS: Record<ItemRarity, string> = {
  common: "일반",
  rare: "레어",
  epic: "에픽",
  legendary: "전설",
};

interface InventoryItem {
  id: string;
  itemId: string;
  equipped: boolean;
  item: ShopItem;
}

export default function ShopPage() {
  const router = useRouter();
  const { isAuthenticated, isLoading: authLoading } = useAuth();
  const [activeCategory, setActiveCategory] = useState<ItemCategory | "all">("all");
  const [items, setItems] = useState<ShopItem[]>([]);
  const [inventory, setInventory] = useState<InventoryItem[]>([]);
  const [gemBalance, setGemBalance] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedItem, setSelectedItem] = useState<ShopItem | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isPurchasing, setIsPurchasing] = useState(false);
  const [activeTab, setActiveTab] = useState<"shop" | "inventory">("shop");
  const [toast, setToast] = useState<string | null>(null);

  const showToast = (message: string) => {
    setToast(message);
    setTimeout(() => setToast(null), 3000);
  };

  const fetchShopItems = useCallback(async () => {
    try {
      const params = new URLSearchParams();
      if (activeCategory !== "all") {
        params.append("category", activeCategory);
      }
      const response = await fetch(`/api/shop/items?${params}`);
      const data = await response.json();
      if (response.ok) {
        setItems(data.items);
      }
    } catch (error) {
      console.error("Failed to fetch shop items:", error);
    }
  }, [activeCategory]);

  const fetchInventory = useCallback(async () => {
    if (!isAuthenticated) return;

    try {
      const response = await fetch("/api/shop/inventory");
      const data = await response.json();
      if (response.ok) {
        setInventory(data.inventory);
      }
    } catch (error) {
      console.error("Failed to fetch inventory:", error);
    }
  }, [isAuthenticated]);

  const fetchProfile = useCallback(async () => {
    if (!isAuthenticated) return;

    try {
      const response = await fetch("/api/game/profile");
      const data = await response.json();
      if (response.ok) {
        setGemBalance(data.profile.gemBalance);
      }
    } catch (error) {
      console.error("Failed to fetch profile:", error);
    }
  }, [isAuthenticated]);

  useEffect(() => {
    if (authLoading) return;

    const loadData = async () => {
      setIsLoading(true);
      await Promise.all([fetchShopItems(), fetchInventory(), fetchProfile()]);
      setIsLoading(false);
    };

    loadData();
  }, [authLoading, fetchShopItems, fetchInventory, fetchProfile]);

  const handlePurchase = async () => {
    if (!selectedItem || !isAuthenticated) return;

    setIsPurchasing(true);
    try {
      const response = await fetch("/api/shop/purchase", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ itemId: selectedItem.id }),
      });

      const data = await response.json();

      if (response.ok) {
        setGemBalance(data.newGemBalance);
        await fetchInventory();
        setIsModalOpen(false);
        setSelectedItem(null);
      } else {
        showToast(data.error);
      }
    } catch (error) {
      console.error("Purchase error:", error);
      showToast("구매에 실패했습니다");
    } finally {
      setIsPurchasing(false);
    }
  };

  const handleEquip = async (userItemId: string, currentEquipped: boolean) => {
    try {
      const response = await fetch("/api/shop/equip", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ userItemId, equipped: !currentEquipped }),
      });

      if (response.ok) {
        await fetchInventory();
      } else {
        const data = await response.json();
        showToast(data.error);
      }
    } catch (error) {
      console.error("Equip error:", error);
    }
  };

  const isOwned = (itemId: string) => {
    return inventory.some((inv) => inv.itemId === itemId);
  };

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
        <h1 className="font-pixel text-lg">상점</h1>
        <div className="flex items-center gap-1 rounded-lg bg-amber-100 px-3 py-1">
          <span className="text-lg">💎</span>
          <span className="font-pixel text-sm text-amber-700">{gemBalance}</span>
        </div>
      </div>

      {/* Tabs */}
      <div className="mb-4 flex gap-2">
        <button
          onClick={() => setActiveTab("shop")}
          className={`flex-1 rounded-xl py-2 font-pixel text-sm transition-colors ${
            activeTab === "shop"
              ? "bg-accent-orange text-white"
              : "bg-frame text-text-secondary"
          }`}
        >
          상점
        </button>
        <button
          onClick={() => setActiveTab("inventory")}
          className={`flex-1 rounded-xl py-2 font-pixel text-sm transition-colors ${
            activeTab === "inventory"
              ? "bg-accent-orange text-white"
              : "bg-frame text-text-secondary"
          }`}
        >
          인벤토리
        </button>
      </div>

      {!isAuthenticated && (
        <Card className="mb-4 bg-amber-50">
          <p className="text-sm text-amber-700">
            로그인하면 아이템을 구매하고 장착할 수 있습니다
          </p>
        </Card>
      )}

      {/* Category Filter */}
      {activeTab === "shop" && (
        <div className="mb-4 flex gap-2 overflow-x-auto pb-2">
          {ITEM_CATEGORIES.map((cat) => (
            <button
              key={cat.id}
              onClick={() => setActiveCategory(cat.id)}
              className={`flex shrink-0 items-center gap-1 rounded-lg px-3 py-1.5 text-xs ${
                activeCategory === cat.id
                  ? "bg-accent-orange text-white"
                  : "bg-frame text-text-secondary"
              }`}
            >
              <span>{cat.emoji}</span>
              <span>{cat.name}</span>
            </button>
          ))}
        </div>
      )}

      {/* Content */}
      <div className="flex-1">
        {isLoading ? (
          <div className="flex h-40 items-center justify-center">
            <LoadingSpinner />
          </div>
        ) : activeTab === "shop" ? (
          items.length === 0 ? (
            <Card className="py-8 text-center">
              <p className="text-text-secondary">상품이 없습니다</p>
            </Card>
          ) : (
            <div className="grid grid-cols-2 gap-3">
              {items.map((item, index) => {
                const owned = isOwned(item.id);
                return (
                  <motion.div
                    key={item.id}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                  >
                    <button
                      onClick={() => {
                        setSelectedItem(item);
                        setIsModalOpen(true);
                      }}
                      disabled={owned}
                      className={`w-full rounded-2xl border-2 p-3 text-left transition-all ${
                        RARITY_COLORS[item.rarity as ItemRarity]
                      } ${owned ? "opacity-60" : "hover:scale-[1.02]"}`}
                    >
                      <div className="mb-2 flex aspect-square items-center justify-center rounded-xl bg-white text-4xl">
                        {item.imageUrl || "📦"}
                      </div>
                      <p className="font-pixel text-sm line-clamp-1">{item.name}</p>
                      <div className="mt-1 flex items-center justify-between">
                        <span className="text-xs text-text-secondary">
                          {RARITY_LABELS[item.rarity as ItemRarity]}
                        </span>
                        {owned ? (
                          <span className="text-xs text-green-600">보유중</span>
                        ) : (
                          <span className="flex items-center gap-1 text-xs text-amber-600">
                            <span>💎</span>
                            {item.priceGem}
                          </span>
                        )}
                      </div>
                    </button>
                  </motion.div>
                );
              })}
            </div>
          )
        ) : (
          /* Inventory Tab */
          inventory.length === 0 ? (
            <Card className="py-8 text-center">
              <p className="text-text-secondary">보유한 아이템이 없습니다</p>
              <Button
                variant="primary"
                size="sm"
                className="mt-4"
                onClick={() => setActiveTab("shop")}
              >
                상점 둘러보기
              </Button>
            </Card>
          ) : (
            <div className="grid grid-cols-2 gap-3">
              {inventory.map((inv, index) => (
                <motion.div
                  key={inv.id}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.05 }}
                >
                  <Card
                    className={`relative ${
                      inv.equipped ? "ring-2 ring-accent-orange" : ""
                    }`}
                  >
                    {inv.equipped && (
                      <span className="absolute -right-1 -top-1 rounded-full bg-accent-orange px-2 py-0.5 text-xs text-white">
                        장착중
                      </span>
                    )}
                    <div className="mb-2 flex aspect-square items-center justify-center rounded-xl bg-maple-cream/50 text-4xl">
                      {inv.item?.imageUrl || "📦"}
                    </div>
                    <p className="font-pixel text-sm line-clamp-1">
                      {inv.item?.name}
                    </p>
                    <p className="mt-1 text-xs text-text-secondary">
                      {RARITY_LABELS[inv.item?.rarity as ItemRarity]}
                    </p>
                    <Button
                      variant={inv.equipped ? "ghost" : "secondary"}
                      size="sm"
                      className="mt-2 w-full"
                      onClick={() => handleEquip(inv.id, inv.equipped)}
                    >
                      {inv.equipped ? "해제" : "장착"}
                    </Button>
                  </Card>
                </motion.div>
              ))}
            </div>
          )
        )}
      </div>

      {/* Gem Charge Button */}
      <div className="mt-4 pb-4">
        <Button
          variant="secondary"
          size="md"
          className="w-full"
          onClick={() => router.push("/donate")}
        >
          💎 젬 충전하기
        </Button>
      </div>

      {/* Purchase Modal */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => {
          setIsModalOpen(false);
          setSelectedItem(null);
        }}
        title="아이템 구매"
      >
        {selectedItem && (
          <div className="space-y-4">
            <div className="flex items-center gap-4">
              <div
                className={`flex h-20 w-20 items-center justify-center rounded-xl border-2 text-4xl ${
                  RARITY_COLORS[selectedItem.rarity as ItemRarity]
                }`}
              >
                {selectedItem.imageUrl || "📦"}
              </div>
              <div>
                <p className="font-pixel text-lg">{selectedItem.name}</p>
                <p className="text-sm text-text-secondary">
                  {RARITY_LABELS[selectedItem.rarity as ItemRarity]}
                </p>
              </div>
            </div>

            {selectedItem.description && (
              <p className="text-sm text-text-secondary">{selectedItem.description}</p>
            )}

            <div className="flex items-center justify-between rounded-lg bg-amber-50 p-3">
              <span className="text-sm">가격</span>
              <span className="flex items-center gap-1 font-pixel text-amber-700">
                <span>💎</span>
                {selectedItem.priceGem}
              </span>
            </div>

            {gemBalance < selectedItem.priceGem && (
              <p className="text-center text-sm text-hp-red">젬이 부족합니다</p>
            )}

            <div className="flex gap-2">
              <Button
                variant="ghost"
                size="md"
                className="flex-1"
                onClick={() => {
                  setIsModalOpen(false);
                  setSelectedItem(null);
                }}
              >
                취소
              </Button>
              <Button
                variant="primary"
                size="md"
                className="flex-1"
                disabled={
                  !isAuthenticated ||
                  gemBalance < selectedItem.priceGem ||
                  isPurchasing
                }
                loading={isPurchasing}
                onClick={handlePurchase}
              >
                구매하기
              </Button>
            </div>
          </div>
        )}
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
