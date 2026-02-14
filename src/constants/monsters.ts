// 7등급 몬스터 정의
export interface MonsterTemplate {
  grade: number;
  levelMin: number;
  levelMax: number;
  baseHp: number;
  names: string[];
  descriptions: string[];
}

export const MONSTER_GRADES: MonsterTemplate[] = [
  {
    grade: 1,
    levelMin: 1,
    levelMax: 10,
    baseHp: 60,
    names: ["버그 슬라임", "널포인터 젤리", "타이포 미생물"],
    descriptions: [
      "코드 속에 숨어사는 초급 버그",
      "null 참조를 좋아하는 젤리",
      "오타를 먹고 자라는 미생물",
    ],
  },
  {
    grade: 2,
    levelMin: 10,
    levelMax: 25,
    baseHp: 100,
    names: ["404 고블린", "무한루프 고스트", "메모리릭 슬라임"],
    descriptions: [
      "페이지를 사라지게 만드는 고블린",
      "탈출할 수 없는 유령",
      "메모리를 야금야금 먹는 슬라임",
    ],
  },
  {
    grade: 3,
    levelMin: 25,
    levelMax: 40,
    baseHp: 150,
    names: ["SQL인젝션 뱀", "XSS 거미", "CSRF 쥐"],
    descriptions: [
      "DB에 독을 주입하는 뱀",
      "스크립트 거미줄을 치는 거미",
      "요청을 위조하는 쥐",
    ],
  },
  {
    grade: 4,
    levelMin: 40,
    levelMax: 55,
    baseHp: 200,
    names: ["데드락 골렘", "레이스컨디션 늑대", "캐시미스 드래곤"],
    descriptions: [
      "모든 것을 멈추게 하는 골렘",
      "타이밍을 노리는 늑대",
      "캐시를 무효화시키는 드래곤",
    ],
  },
  {
    grade: 5,
    levelMin: 55,
    levelMax: 70,
    baseHp: 250,
    names: ["DDoS 타이탄", "랜섬웨어 기사", "제로데이 암살자"],
    descriptions: [
      "트래픽 폭풍의 거인",
      "데이터를 인질로 잡는 기사",
      "알려지지 않은 취약점의 암살자",
    ],
  },
  {
    grade: 6,
    levelMin: 70,
    levelMax: 85,
    baseHp: 300,
    names: ["카오스 엔지니어", "장애 폭풍 드래곤", "다운타임 마왕"],
    descriptions: [
      "시스템을 혼란에 빠뜨리는 존재",
      "연쇄 장애를 일으키는 드래곤",
      "서비스를 멈추게 하는 마왕",
    ],
  },
  {
    grade: 7,
    levelMin: 85,
    levelMax: 100,
    baseHp: 400,
    names: ["레거시 모놀리스", "기술부채 타이탄", "스파게티 코드 신"],
    descriptions: [
      "거대한 레거시 시스템의 화신",
      "누적된 기술 부채의 거인",
      "얽히고설킨 코드의 신",
    ],
  },
];
