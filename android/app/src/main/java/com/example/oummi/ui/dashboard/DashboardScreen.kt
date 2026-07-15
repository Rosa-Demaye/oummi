package com.example.oummi.ui.dashboard

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.oummi.R

// Colors based on the screenshot
val DashboardBg = Color(0xFFFFFBF8)
val PhaseBannerColor = Color(0xFFE58B6D)
val JournalCardBg = Color(0xFFFFF1F1)
val MoodCardBg = Color(0xFFF1FAF5)
val EducationCardBg = Color(0xFFF1F5FA)
val CommunityCardBg = Color(0xFFFAF5F1)
val AccentColor = Color(0xFFE58B6D)
val TextDark = Color(0xFF2D2D2D)
val TextLight = Color(0xFF757575)

@Composable
fun DashboardScreen(modifier: Modifier = Modifier) {
    Scaffold(
        modifier = modifier.fillMaxSize(),
        containerColor = DashboardBg,
        topBar = {
            DashboardHeader()
        },
        bottomBar = {
            DashboardBottomNavigation()
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .padding(horizontal = 20.dp)
                .fillMaxSize()
        ) {
            Spacer(modifier = Modifier.height(16.dp))
            PhaseBanner()
            Spacer(modifier = Modifier.height(24.dp))
            ActionGrid()
            Spacer(modifier = Modifier.height(24.dp))
            DailyTipCard()
        }
    }
}

@Composable
fun DashboardHeader() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 24.dp, start = 20.dp, end = 20.dp, bottom = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(
                text = stringResource(R.string.dashboard_greeting),
                style = MaterialTheme.typography.bodyLarge,
                color = TextLight
            )
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = stringResource(R.string.dashboard_user_name),
                    style = MaterialTheme.typography.headlineMedium,
                    fontWeight = FontWeight.Bold,
                    color = TextDark
                )
                Spacer(modifier = Modifier.width(4.dp))
                Text(text = "🌸", fontSize = 20.sp)
            }
        }
        Row(verticalAlignment = Alignment.CenterVertically) {
            // Notification Icon
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text(text = "🔔", fontSize = 20.sp)
            }
            Spacer(modifier = Modifier.width(12.dp))
            // Profile Icon
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    .background(Color(0xFFE59A7D)),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "AK",
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 14.sp
                )
            }
        }
    }
}

@Composable
fun PhaseBanner() {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
            .clip(RoundedCornerShape(28.dp))
            .background(PhaseBannerColor),
        contentAlignment = Alignment.CenterStart
    ) {
        Row(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = stringResource(R.string.dashboard_phase_title),
                color = Color.White,
                fontWeight = FontWeight.Bold,
                letterSpacing = 1.sp
            )
            Text(text = "🌙", color = Color.White.copy(alpha = 0.3f), fontSize = 24.sp)
        }
    }
}

@Composable
fun ActionGrid() {
    Column {
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            DashboardCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.dashboard_journal_title),
                subtitle = stringResource(R.string.dashboard_journal_subtitle),
                backgroundColor = JournalCardBg,
                icon = "📝"
            )
            DashboardCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.dashboard_humeur_title),
                subtitle = stringResource(R.string.dashboard_humeur_subtitle),
                backgroundColor = MoodCardBg,
                icon = "😊"
            )
        }
        Spacer(modifier = Modifier.height(16.dp))
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            DashboardCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.dashboard_education_title),
                subtitle = stringResource(R.string.dashboard_education_subtitle),
                backgroundColor = EducationCardBg,
                icon = "📚"
            )
            DashboardCard(
                modifier = Modifier.weight(1f),
                title = stringResource(R.string.dashboard_communaute_title),
                subtitle = stringResource(R.string.dashboard_communaute_subtitle),
                backgroundColor = CommunityCardBg,
                icon = "👥"
            )
        }
    }
}

@Composable
fun DashboardCard(
    title: String,
    subtitle: String,
    backgroundColor: Color,
    icon: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .height(140.dp),
        colors = CardDefaults.cardColors(containerColor = backgroundColor),
        shape = RoundedCornerShape(24.dp)
    ) {
        Column(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxSize(),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(Color.White.copy(alpha = 0.5f)),
                contentAlignment = Alignment.Center
            ) {
                Text(text = icon, fontSize = 20.sp)
            }
            Column {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = TextDark
                )
                Text(
                    text = subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = TextLight,
                    lineHeight = 14.sp
                )
            }
        }
    }
}

@Composable
fun DailyTipCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        shape = RoundedCornerShape(24.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Row(
            modifier = Modifier.padding(20.dp),
            verticalAlignment = Alignment.Top
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    .background(Color(0xFFFFF8E1)),
                contentAlignment = Alignment.Center
            ) {
                Text(text = "💡", fontSize = 20.sp)
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column {
                Text(
                    text = stringResource(R.string.dashboard_tip_title),
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = TextDark
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = stringResource(R.string.dashboard_tip_content),
                    style = MaterialTheme.typography.bodyMedium,
                    color = TextLight,
                    lineHeight = 20.sp
                )
            }
        }
    }
}

@Composable
fun DashboardBottomNavigation() {
    NavigationBar(
        containerColor = Color.White,
        tonalElevation = 8.dp
    ) {
        NavigationBarItem(
            selected = true,
            onClick = { },
            icon = { Text(text = "🏠", fontSize = 20.sp) },
            label = { Text(stringResource(R.string.nav_home)) },
            colors = NavigationBarItemDefaults.colors(
                selectedIconColor = AccentColor,
                selectedTextColor = AccentColor,
                indicatorColor = Color.Transparent
            )
        )
        NavigationBarItem(
            selected = false,
            onClick = { },
            icon = { Text(text = "❤️", fontSize = 20.sp) },
            label = { Text(stringResource(R.string.nav_cycle)) }
        )
        NavigationBarItem(
            selected = false,
            onClick = { },
            icon = { Text(text = "📅", fontSize = 20.sp) },
            label = { Text(stringResource(R.string.nav_calendar)) }
        )
        NavigationBarItem(
            selected = false,
            onClick = { },
            icon = { Text(text = "👥", fontSize = 20.sp) },
            label = { Text(stringResource(R.string.nav_community)) }
        )
        NavigationBarItem(
            selected = false,
            onClick = { },
            icon = { Text(text = "👤", fontSize = 20.sp) },
            label = { Text(stringResource(R.string.nav_profile)) }
        )
    }
}

@Preview(showBackground = true, widthDp = 360, heightDp = 800)
@Composable
fun DashboardScreenPreview() {
    MaterialTheme {
        DashboardScreen()
    }
}
