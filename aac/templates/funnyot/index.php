<?php
defined('MYAAC') or die('Direct access not allowed!');

if(isset($config['boxes']))
	$config['boxes'] = explode(",", $config['boxes']);

$serverName = $config['lua']['serverName'] ?? 'FunnyOt';
$discordUrl = $config['discord_link'] ?? '#';
$serverPlayers = isset($status['players']) ? $status['players'] : 0;
$serverPlayersMax = isset($status['playersMax']) ? $status['playersMax'] : 0;
$serverUptimeStr = isset($status['uptimeReadable']) ? $status['uptimeReadable'] : 'Unknown';
$isOnline = isset($status['online']) && $status['online'];
?>
<!doctype html>
<html lang="pt-BR">
<head>
	<?php echo template_place_holder('head_start'); ?>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />

	<link rel="shortcut icon" href="<?php echo $template_path; ?>/images/favicon.ico" type="image/x-icon" />
	<link rel="icon" href="<?php echo $template_path; ?>/images/favicon.ico" type="image/x-icon" />

	<!-- Fonts: Cinzel (display) + Inter (sans) -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

	<!-- Tailwind CDN (v3) -->
	<script src="https://cdn.tailwindcss.com"></script>

	<!-- CSS customizado FunnyOt -->
	<link rel="stylesheet" href="<?php echo $template_path; ?>/style.css?v=1" />

	<!-- myAAC base scripts -->
	<link rel="stylesheet" type="text/css" href="<?php echo BASE_URL; ?>tools/css/messages.css" />
	<script type="text/javascript" src="<?php echo BASE_URL; ?>tools/ext/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="<?php echo BASE_URL; ?>tools/basic.js"></script>

	<?php echo template_place_holder('head_end'); ?>
</head>
<body>

<!-- Container principal -->
<div class="max-w-[1400px] mx-auto px-4 lg:px-6 pb-12">

	<!-- ============ HEADER ============ -->
	<header class="w-full pt-8 pb-12 relative z-10">
		<div class="flex flex-col items-center justify-center relative cursor-pointer group">
			<!-- Glow atrás do título -->
			<div class="absolute inset-0 bg-amber-500 opacity-20 blur-[80px] rounded-full pointer-events-none"></div>

			<!-- Título com swords -->
			<h1 class="hero-title text-6xl md:text-8xl lg:text-9xl m-0 transform transition-transform duration-500 group-hover:scale-105">
				<!-- Sword left (rotated -45) -->
				<svg class="text-amber-500 w-14 h-14 md:w-24 md:h-24 inline-block md:-mr-4" style="transform: rotate(-45deg); filter: drop-shadow(0 0 15px rgba(251,191,36,0.5));" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M14.5 17.5 3 6V3h3l11.5 11.5M13 19l6-6M16 16l4 4M19 21l2-2M15 5l4-4M18 6l3-3M16 6l2 2"/></svg>
				<span class="px-2"><?php echo htmlspecialchars($serverName); ?></span>
				<!-- Sword right (rotated 45) -->
				<svg class="text-amber-500 w-14 h-14 md:w-24 md:h-24 inline-block md:-ml-4" style="transform: rotate(45deg) scaleX(-1); filter: drop-shadow(0 0 15px rgba(251,191,36,0.5));" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M14.5 17.5 3 6V3h3l11.5 11.5M13 19l6-6M16 16l4 4M19 21l2-2M15 5l4-4M18 6l3-3M16 6l2 2"/></svg>
			</h1>

			<!-- Subtitle -->
			<span class="hero-subtitle text-base md:text-xl mt-3 pt-2 px-8 font-display font-medium">
				A Legendary Open Tibia Server
			</span>
		</div>
	</header>

	<!-- ============ MAIN LAYOUT (3 colunas) ============ -->
	<div class="flex flex-col md:flex-row gap-5 lg:gap-6 items-start relative z-10 w-full xl:max-w-[1280px] xl:mx-auto">

		<!-- ===== SIDEBAR ESQUERDA ===== -->
		<div class="flex-none order-2 md:order-1 w-full md:w-[240px] lg:w-[260px] shrink-0">
			<aside class="w-full flex flex-col">

				<!-- Painel Account Access -->
				<div class="collapsible-panel" data-panel="account-access">
					<button type="button" class="plaque" data-toggle="account-access">
						<div class="plaque-inner"></div>
						<div class="plaque-frame-1"></div>
						<div class="plaque-frame-2"></div>
						<div class="plaque-corner tl"></div>
						<div class="plaque-corner tr"></div>
						<div class="plaque-corner bl"></div>
						<div class="plaque-corner br"></div>
						<div class="plaque-bar-top"></div>
						<div class="plaque-bar-bottom"></div>
						<div class="plaque-text">
							<div class="flex items-center justify-between w-full">
								<span class="flex items-center gap-2"><span class="text-amber-200">🔑</span> Account Access</span>
								<span class="chevron">▾</span>
							</div>
						</div>
					</button>
					<div class="collapsible-content" data-content="account-access">
						<div class="collapsible-inner">
							<div class="panel-body">
								<p class="text-[11px] text-amber-200/60 text-center font-display tracking-widest uppercase mb-3">Enter the realm</p>
								<?php if ($logged): ?>
									<a href="<?php echo getLink('account/manage'); ?>" class="premium-button mb-2">My Account</a>
									<a href="<?php echo getLink('logout'); ?>" class="premium-button">Logout</a>
								<?php else: ?>
									<a href="<?php echo getLink('account/manage'); ?>" class="premium-button mb-2">Login</a>
									<a href="<?php echo getLink('account/create'); ?>" class="premium-button">Create Account</a>
								<?php endif; ?>
							</div>
						</div>
					</div>
				</div>

				<!-- Painel News -->
				<div class="collapsible-panel" data-panel="news">
					<button type="button" class="plaque" data-toggle="news">
						<div class="plaque-inner"></div>
						<div class="plaque-frame-1"></div>
						<div class="plaque-frame-2"></div>
						<div class="plaque-corner tl"></div>
						<div class="plaque-corner tr"></div>
						<div class="plaque-corner bl"></div>
						<div class="plaque-corner br"></div>
						<div class="plaque-bar-top"></div>
						<div class="plaque-bar-bottom"></div>
						<div class="plaque-text">
							<div class="flex items-center justify-between w-full">
								<span class="flex items-center gap-2"><span class="text-amber-400">📰</span> News</span>
								<span class="chevron">▾</span>
							</div>
						</div>
					</button>
					<div class="collapsible-content" data-content="news">
						<div class="collapsible-inner">
							<div class="panel-body">
								<a href="<?php echo getLink('news'); ?>" class="menu-link"><span class="marker"></span>Latest News</a>
								<a href="<?php echo getLink('news/archive'); ?>" class="menu-link"><span class="marker"></span>News Archive</a>
								<a href="<?php echo getLink('change-log'); ?>" class="menu-link"><span class="marker"></span>Changelog</a>
							</div>
						</div>
					</div>
				</div>

				<!-- Painel Account -->
				<div class="collapsible-panel" data-panel="account">
					<button type="button" class="plaque" data-toggle="account">
						<div class="plaque-inner"></div>
						<div class="plaque-frame-1"></div>
						<div class="plaque-frame-2"></div>
						<div class="plaque-corner tl"></div>
						<div class="plaque-corner tr"></div>
						<div class="plaque-corner bl"></div>
						<div class="plaque-corner br"></div>
						<div class="plaque-bar-top"></div>
						<div class="plaque-bar-bottom"></div>
						<div class="plaque-text">
							<div class="flex items-center justify-between w-full">
								<span class="flex items-center gap-2"><span class="text-amber-400">👤</span> Account</span>
								<span class="chevron">▾</span>
							</div>
						</div>
					</button>
					<div class="collapsible-content" data-content="account">
						<div class="collapsible-inner">
							<div class="panel-body">
								<a href="<?php echo getLink('account/manage'); ?>" class="menu-link"><span class="marker"></span>Manage Account</a>
								<a href="<?php echo getLink('account/create'); ?>" class="menu-link"><span class="marker"></span>Create Account</a>
								<a href="<?php echo getLink('account/lost'); ?>" class="menu-link"><span class="marker"></span>Lost Account?</a>
								<a href="<?php echo getLink('rules'); ?>" class="menu-link"><span class="marker"></span>Server Rules</a>
								<a href="<?php echo getLink('downloads'); ?>" class="menu-link"><span class="marker"></span>Downloads</a>
							</div>
						</div>
					</div>
				</div>

				<!-- Painel Community -->
				<div class="collapsible-panel" data-panel="community">
					<button type="button" class="plaque" data-toggle="community">
						<div class="plaque-inner"></div>
						<div class="plaque-frame-1"></div>
						<div class="plaque-frame-2"></div>
						<div class="plaque-corner tl"></div>
						<div class="plaque-corner tr"></div>
						<div class="plaque-corner bl"></div>
						<div class="plaque-corner br"></div>
						<div class="plaque-bar-top"></div>
						<div class="plaque-bar-bottom"></div>
						<div class="plaque-text">
							<div class="flex items-center justify-between w-full">
								<span class="flex items-center gap-2"><span class="text-amber-400">👥</span> Community</span>
								<span class="chevron">▾</span>
							</div>
						</div>
					</button>
					<div class="collapsible-content" data-content="community">
						<div class="collapsible-inner">
							<div class="panel-body">
								<a href="<?php echo getLink('characters'); ?>" class="menu-link"><span class="marker"></span>Characters</a>
								<a href="<?php echo getLink('online'); ?>" class="menu-link"><span class="marker"></span>Who is Online?</a>
								<a href="<?php echo getLink('highscores'); ?>" class="menu-link"><span class="marker"></span>Highscores</a>
								<a href="<?php echo getLink('last-kills'); ?>" class="menu-link"><span class="marker"></span>Last Kills</a>
								<a href="<?php echo getLink('houses'); ?>" class="menu-link"><span class="marker"></span>Houses</a>
								<a href="<?php echo getLink('guilds'); ?>" class="menu-link"><span class="marker"></span>Guilds</a>
							</div>
						</div>
					</div>
				</div>

				<!-- Painel Library -->
				<div class="collapsible-panel" data-panel="library">
					<button type="button" class="plaque" data-toggle="library">
						<div class="plaque-inner"></div>
						<div class="plaque-frame-1"></div>
						<div class="plaque-frame-2"></div>
						<div class="plaque-corner tl"></div>
						<div class="plaque-corner tr"></div>
						<div class="plaque-corner bl"></div>
						<div class="plaque-corner br"></div>
						<div class="plaque-bar-top"></div>
						<div class="plaque-bar-bottom"></div>
						<div class="plaque-text">
							<div class="flex items-center justify-between w-full">
								<span class="flex items-center gap-2"><span class="text-amber-400">📚</span> Library</span>
								<span class="chevron">▾</span>
							</div>
						</div>
					</button>
					<div class="collapsible-content collapsed" data-content="library">
						<div class="collapsible-inner">
							<div class="panel-body">
								<a href="<?php echo getLink('serverinfo'); ?>" class="menu-link"><span class="marker"></span>Server Info</a>
								<a href="<?php echo getLink('monsters'); ?>" class="menu-link"><span class="marker"></span>Monsters</a>
								<a href="<?php echo getLink('spells'); ?>" class="menu-link"><span class="marker"></span>Spells</a>
								<a href="<?php echo getLink('commands'); ?>" class="menu-link"><span class="marker"></span>Player Commands</a>
								<a href="<?php echo getLink('faq'); ?>" class="menu-link"><span class="marker"></span>FAQ</a>
							</div>
						</div>
					</div>
				</div>

			</aside>
		</div>

		<!-- ===== CONTEUDO PRINCIPAL ===== -->
		<div class="flex-1 order-1 md:order-2 w-full min-w-0">
			<main class="flex-1 flex flex-col gap-4">

				<!-- Top action bar (Discord, Instagram, idiomas) -->
				<div class="panel-premium-box rounded p-3 flex flex-col sm:flex-row items-center justify-between gap-4 shadow-lg">
					<div class="flex items-center gap-4 text-sm font-medium">
						<a href="<?php echo $discordUrl; ?>" target="_blank" class="text-amber-200/80 hover:text-amber-400 transition-colors flex items-center gap-2 no-underline">
							<span class="w-1.5 h-1.5 rounded-full bg-indigo-500" style="box-shadow: 0 0 5px #6366f1;"></span> Discord
						</a>
						<a href="#" class="text-amber-200/80 hover:text-amber-400 transition-colors flex items-center gap-2 no-underline">
							<span class="w-1.5 h-1.5 rounded-full bg-pink-500" style="box-shadow: 0 0 5px #ec4899;"></span> Instagram
						</a>
					</div>
					<div class="flex gap-2">
						<span class="text-xs text-amber-100 bg-[#1b2a40] px-2.5 py-1 rounded-sm cursor-default border border-[#3b5278]" style="box-shadow: inset 0 0 5px rgba(0,0,0,0.5);">🇧🇷 PT</span>
					</div>
				</div>

				<!-- Tickers (notícias rápidas) -->
				<?php $tickersHtml = function_exists('tickers') ? tickers() : ''; ?>
				<?php if(!empty($tickersHtml)): ?>
					<div class="panel-premium-box rounded p-4">
						<?php echo $tickersHtml; ?>
					</div>
				<?php endif; ?>

				<!-- Wrapper de news/conteúdo -->
				<div class="panel-premium-box rounded shadow-xl pb-4 overflow-hidden mt-2">
					<!-- Plaque header LATEST NEWS -->
					<div class="mb-1">
						<div class="plaque" style="cursor: default;">
							<div class="plaque-inner"></div>
							<div class="plaque-frame-1"></div>
							<div class="plaque-frame-2"></div>
							<div class="plaque-corner tl"></div>
							<div class="plaque-corner tr"></div>
							<div class="plaque-corner bl"></div>
							<div class="plaque-corner br"></div>
							<div class="plaque-bar-top"></div>
							<div class="plaque-bar-bottom"></div>
							<div class="plaque-text"><?php echo isset($title) ? htmlspecialchars($title) : 'Latest News'; ?></div>
						</div>
					</div>

					<!-- Conteúdo da página (renderizado pelo myAAC) -->
					<div class="p-4 funnyot-content">
						<?php echo template_place_holder('center_top') . $content; ?>
					</div>
				</div>

			</main>
		</div>

		<!-- ===== SIDEBAR DIREITA ===== -->
		<div class="flex-none order-3 md:order-3 w-full md:w-[240px] lg:w-[260px] shrink-0">
			<aside class="w-full flex flex-col gap-2">

				<!-- Download/Play Now -->
				<div class="mb-[24px] mt-1">
					<div class="plaque green" style="cursor: pointer;" onclick="window.location='<?php echo getLink('downloads'); ?>'">
						<div class="plaque-inner"></div>
						<div class="plaque-frame-1"></div>
						<div class="plaque-frame-2"></div>
						<div class="plaque-corner tl"></div>
						<div class="plaque-corner tr"></div>
						<div class="plaque-corner bl"></div>
						<div class="plaque-corner br"></div>
						<div class="plaque-bar-top"></div>
						<div class="plaque-bar-bottom"></div>
						<div class="plaque-text">
							<div class="flex items-center justify-center gap-3 group">
								<span class="text-[#a7f3d0]" style="font-size: 28px;">⬇</span>
								<div class="flex flex-col items-start gap-1">
									<span class="font-display font-black tracking-[0.15em] text-[18px] text-[#fcebbb] leading-none">PLAY NOW</span>
									<span class="text-[9px] text-green-300 uppercase tracking-widest font-bold leading-none">Download Client</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Server Info -->
				<div class="collapsible-panel" data-panel="server-info">
					<button type="button" class="plaque" data-toggle="server-info">
						<div class="plaque-inner"></div>
						<div class="plaque-frame-1"></div>
						<div class="plaque-frame-2"></div>
						<div class="plaque-corner tl"></div>
						<div class="plaque-corner tr"></div>
						<div class="plaque-corner bl"></div>
						<div class="plaque-corner br"></div>
						<div class="plaque-bar-top"></div>
						<div class="plaque-bar-bottom"></div>
						<div class="plaque-text">
							<div class="flex items-center justify-between w-full">
								<span class="flex items-center gap-2"><span class="text-amber-400">🛡️</span> Server Info</span>
								<span class="chevron">▾</span>
							</div>
						</div>
					</button>
					<div class="collapsible-content" data-content="server-info">
						<div class="collapsible-inner">
							<div class="panel-body">
								<div class="flex flex-col gap-3 items-center">
									<div class="w-full p-3 rounded flex flex-col items-center justify-center border border-[#4a3620] bg-black/40">
										<span class="text-[10px] text-amber-400/80 uppercase tracking-widest font-display font-bold mb-1">Uptime</span>
										<div class="text-xl font-mono font-bold text-amber-200" style="text-shadow: 0 0 8px rgba(251,191,36,0.5);">
											<?php echo htmlspecialchars($serverUptimeStr); ?>
										</div>
									</div>

									<?php if ($isOnline): ?>
									<div class="w-full p-2.5 rounded flex items-center justify-center gap-2 text-sm text-green-400 font-bold border border-[#233a25] bg-[#0d1f11]" style="box-shadow: inset 0 2px 5px rgba(0,0,0,0.5);">
										<span class="status-online-pulse"></span>
										<span class="tracking-wide"><?php echo number_format($serverPlayers); ?> Players Online</span>
									</div>
									<?php else: ?>
									<div class="w-full p-2.5 rounded flex items-center justify-center gap-2 text-sm text-red-400 font-bold border border-[#3a2323] bg-[#1f0b0b]" style="box-shadow: inset 0 2px 5px rgba(0,0,0,0.5);">
										<span class="w-3 h-3 rounded-full bg-red-500"></span>
										<span class="tracking-wide">Server Offline</span>
									</div>
									<?php endif; ?>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Webshop banner -->
				<div class="panel-premium-box overflow-hidden mb-4 group cursor-pointer mt-2" onclick="window.location='<?php echo getLink('points'); ?>'">
					<div class="bg-gradient-to-r from-transparent via-amber-500/20 to-transparent p-2 flex justify-center border-b border-amber-900/50">
						<h2 class="font-display font-bold text-amber-200 text-xs tracking-widest flex items-center gap-2 m-0">
							<span class="text-amber-400">✨</span> WEBSHOP <span class="text-amber-400">✨</span>
						</h2>
					</div>
					<div class="h-32 relative overflow-hidden flex items-center justify-center bg-[#070a10]">
						<div class="absolute inset-0 bg-cover bg-center opacity-40 group-hover:scale-105 group-hover:opacity-60 transition-all duration-700" style="background-image: url('https://images.unsplash.com/photo-1601518174169-c09eb2add67b?q=80&w=600&auto=format&fit=crop'); mix-blend-mode: screen;"></div>
						<div class="absolute inset-0 bg-gradient-to-t from-[rgba(11,17,26,1)] to-transparent opacity-90"></div>
						<div class="relative z-10 text-center px-4 mt-8">
							<p class="text-amber-100 font-display italic text-lg m-0" style="text-shadow: 0 2px 4px rgba(0,0,0,0.8);">Exclusive Outfits</p>
						</div>
					</div>
					<div class="p-3 relative z-20">
						<button type="button" class="premium-button text-[11px] tracking-widest">Get Funny Coins</button>
					</div>
				</div>

				<!-- Discord Community -->
				<a href="<?php echo $discordUrl; ?>" target="_blank" class="panel-premium-box mt-2 no-underline block">
					<div class="border-b border-[#5865F2]/30 p-3 flex justify-center rounded-t-md" style="background: rgba(88,101,242,0.2);">
						<h3 class="font-display font-bold text-[#e1e2f3] text-sm tracking-wider flex items-center gap-2 m-0">
							<span style="color: #5865F2;">💬</span> Join Community
						</h3>
					</div>
					<div class="p-4 flex flex-col items-center text-center gap-3">
						<p class="text-[13px] text-slate-300 font-medium leading-tight m-0">Chat with the FunnyOt community, share loot, find guilds!</p>
						<button type="button" class="w-full py-2 text-white font-bold text-xs uppercase tracking-widest rounded shadow-md transition-all border" style="background: #5865F2; border-color: #4752C4;">
							💬 Discord
						</button>
					</div>
				</a>

			</aside>
		</div>

	</div> <!-- /main layout -->

</div> <!-- /container -->

<!-- ============ FOOTER ============ -->
<footer class="py-6 text-center text-xs text-amber-100/60 relative z-10 mt-12 mb-8 bg-transparent">
	<div class="max-w-4xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4 px-4 font-sans">
		<p class="font-bold m-0">© <?php echo date('Y'); ?> <?php echo htmlspecialchars($serverName); ?>.</p>
		<div class="flex items-center gap-2 panel-premium-box px-3 py-1.5 rounded-full border border-amber-900/50">
			<span class="w-2 h-2 rounded-full bg-green-500" style="box-shadow: 0 0 8px #22c55e;"></span>
			<span class="font-bold text-amber-100"><?php echo template_footer(); ?></span>
		</div>
	</div>
</footer>

<!-- Script de collapsible panels -->
<script src="<?php echo $template_path; ?>/script.js?v=1"></script>

</body>
</html>
<!-- Powered by MyAAC :: https://www.my-aac.org/ -->
