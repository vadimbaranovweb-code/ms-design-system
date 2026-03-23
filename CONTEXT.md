# MSDesignSystem — Project Context
> Этот файл обновляется в конце каждой сессии с Claude Code.
> Читай его первым делом чтобы понять где мы находимся.

_Last updated: 2026-03-23_

## Репо
GitHub: https://github.com/vadimbaranovweb-code/ms-design-system
Figma: https://www.figma.com/design/pBejCIZ8Kua31tXOQnTvVc/MS-Design-system-2

## Структура
```
MSDesignSystem/DesignSystem/
├── Tokens/
│   └── DesignTokens.swift
└── Components/
    ├── Actions/
    │   └── DSButton.swift
    ├── Controls/
    │   ├── DSCheckbox.swift
    │   ├── DSToggle.swift
    │   ├── DSSwitchToggle.swift
    │   ├── DSRadioButton.swift
    │   ├── DSButtonGroup.swift      ← NEW (3933-44772 / 3933-44623)
    │   └── DSSlider.swift           ← NEW (5070-14621)
    ├── Inputs/
    │   ├── DSInputField.swift
    │   └── DSTextArea.swift         ← NEW (1750-44243)
    ├── Display/
    │   └── DSBadge.swift
    ├── Feedback/
    │   ├── DSAlert.swift            (+ .dsToast modifier)
    │   ├── DSProgressBar.swift      (+ DSStepProgressBar)
    │   ├── DSTooltip.swift          (+ .dsTooltip modifier)
    │   └── DSStatusModal.swift      (+ .dsStatusModal modifier)
    └── Layout/
        ├── DSDivider.swift
        └── DSCard.swift
```

## Готовые компоненты

| Компонент | Ключевые параметры |
|-----------|-------------------|
| DSButton | type/style/size/isLoading/isDisabled |
| DSInputField | text, label, hint, error, leadingIcon, trailingIcon |
| DSTextArea | text, label, maxCharacters, errorMessage, hint, isDisabled |
| DSBadge | text, type, style, size |
| DSCheckbox | isChecked, isIndeterminate, isDisabled, label |
| DSSwitchToggle | selectedIndex, tabs: [DSSwitchTab] |
| DSRadioButton / DSRadioGroup<T> | isSelected / selection binding |
| DSToggle | isOn, size, isDisabled |
| DSButtonGroup | items, selectedId, size (.small / .xxSmall) |
| DSSlider | value, range, step, label, showTooltip, isDisabled |
| DSDivider | type (.line / .textLine / .iconButton / …) |
| DSCard<Content> | style (.elevated/.outlined/.surface/.flat), title, onTap |
| DSAlert | status, style (.filled/.lighter), size (.compact/.large) |
| DSProgressBar / DSStepProgressBar | progress / totalSteps+currentStep |
| DSTooltip | text, size, theme, tailPosition |
| DSStatusModal | type, alignment (.default/.centered) |

## В очереди

| Компонент | Figma node | Заметка |
|-----------|------------|---------|
| DSBottomSheet | — | нужен для DSSelect |
| DSSelect | — | поиск + выбор языка, строится на BottomSheet |
| DSAvatar | ждём ссылку | — |
| DSTag / DSChip | ждём ссылку | — |

## Ключевые паттерны

- **Токены**: только `DS.*` — никаких хардкодных цветов
- **ViewModifier API**: `.dsToast()`, `.dsTooltip()`, `.dsStatusModal()`
- **Generic slots**: `DSCard<Content: View>`, `DSRadioGroup<T: Hashable>`
- **Animated tab**: `@Namespace` + `matchedGeometryEffect` (DSSwitchToggle)
- **Inner shadow**: overlay `LinearGradient` от `#162664.opacity(0.32)` → `.clear`
- **Git**: `git add [files] && git commit && git push origin main`
