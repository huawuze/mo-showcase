# mo-showcase 版本历史

## v1.2.0（2026-10-27）

**页面级动效结构 P1 + 版本星座 P2**（不凝拍板「以后按新标准做」，标准已写入 `mo-session-end` §0.3 ③）

- **版本星座 P2**：时间线上方 760×320 Canvas 2D 伪 3D 视图，21 个节点按五条主题线着色（内核/自检/能力/产品/设计），可拖动旋转、点击节点跳转并触发该卡动效；图例在右上，提示「上 = 新」
  - **0 依赖**：不用 Three.js（等价效果下体积 60KB → 1/10）；**内联无新文件**，推送白名单不变
  - 仅可见时 rAF 绘制（IntersectionObserver 暂停）；30fps 上限；`prefers-reduced-motion` 静态渲染
  - 数据源：`VERSION-GRAPH.md`（五线归属为**推断 D 级**，改版须同步）

- **滚动入场**：IntersectionObserver 逐卡 reveal，同批 60ms 错峰；`js-motion` 类由 head 内联脚本按能力开关，2.5s 未初始化自动取消隐藏（JS 失败也不白屏）
- **阅读进度**：顶部 2px 进度条（`scaleX`）+ 时间线随滚动生长（`timeline-progress`），rAF 节流 + passive 监听
- **统计数字滚动**：memory / hooks / depth / sessions 从 0 计数到目标值（800ms ease-out）
- **触屏补齐**：`@media (hover:none)` 显示「轻触查看动效」提示 + `:active` 边框反馈（此前所有动效绑 hover，手机上等于没有）
- **修复（存量 bug）**：`#stat-turns` 元素不存在 → `getElementById` 返回 null → `TypeError` → `.catch` 误把 tagline 标成「· 离线模式」，且 freshness 提示**从未显示**。改为存在性判断后，页面恢复显示「数据已过 N 天」
- **修复（存量 bug）**：`eval_pass/eval_total` 为 null 时显示「null/null」→ 改为「—」
- **约束**：新增依赖 **0**；不改变原有 25 段卡内动效；`prefers-reduced-motion` 下全静止
- **验证**：`fe_taste_lint --mandatory --gate 2` → 11/11，仅存量 `important×3`；6 个 script 块 `node --check` 全过；1440×12000 视口下 21 张卡全部 `in-view`、时间线进度 100%；1440×1000 截图正常

## v1.1.0（2026-08-06）

- **CSS 架构全面升级**：oklch 色彩系统 + clamp() 流体排版 + 分层阴影（shadow-a/b）
- **主题切换**：data-theme 三态切换（light/dark/system）+ localStorage 持久化
- **可访问性**：skip-link + sr-only + focus-visible + prefers-reduced-motion
- **设计 tokens**：--surface-1/2/3, --text-1/2, --border 统一变量
- **品质**：fe_taste_lint.py 11/11 满分 + mandatory 三项全过
- **内容完整保留**：15 个版本卡片一字未动

## v1.0.0（2026-08-02）

- 新增 v2.1「真Mo」版本条目（上下文同源+附录D落地+think bubble）
- 原 v0.9.0「三体」合并入 v2.0 条目（涵盖 07-30 ~ 08-01 完整周期）
- CSS 版本号更新为 v1.0.0
- 部署路径：DaYou /showcase（mo.moask.cc/showcase）

## v0.8.0（2026-07-30）

- 明暗双模 + hover 对比优化
- 版本条目更新至 v0.9.0「三体」
