package com.example.oummi.ui.dashboard

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
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

private val OummiDashboardBg = Color(0xFFFFFBF8)
private val OummiAccentColor = Color(0xFFE58B6D)
private val OummiEducationCardBg = Color(0xFFF1F5FA)
private val OummiCommunityCardBg = Color(0xFFFAF5F1)
private val OummiJournalCardBg = Color(0xFFFFF1F1)
private val OummiMoodCardBg = Color(0xFFF1FAF5)
private val OummiTextDark = Color(0xFF2D2D2D)
private val OummiTextLight = Color(0xFF757575)
private val OummiNavSelected = Color(0xFFD36F55)
private val OummiChipPeach = Color(0xFFFAF5F1)
private val OummiChipGreen = Color(0xFFF1FAF5)

@Composable
fun OummiDashboard(modifier: Modifier = Modifier) {
    Scaffold(
        modifier = modifier.fillMaxSize(),
        containerColor = OummiDashboardBg,
        bottomBar = {
            OummiBottomNavigation()
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp)
        ) {
            Spacer(modifier = Modifier.height(24.dp))
            OummiHeader()
            Spacer(modifier = Modifier.height(24.dp))
            
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                OummiDashboardActionCard(
                    modifier = Modifier.weight(1f),
                    title = stringResource(R.string.dashboard_journal_title),
                    subtitle = stringResource(R.string.dashboard_journal_subtitle),
                    backgroundColor = OummiJournalCardBg,
                    icon = "📝"
                )
                OummiDashboardActionCard(
                    modifier = Modifier.weight(1f),
                    title = stringResource(R.string.dashboard_humeur_title),
                    subtitle = stringResource(R.string.dashboard_humeur_subtitle),
                    backgroundColor = OummiMoodCardBg,
                    icon = "😊"
                )
            }
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                OummiDashboardActionCard(
                    modifier = Modifier.weight(1f),
                    title = stringResource(R.string.dashboard_education_title),
                    subtitle = stringResource(R.string.dashboard_education_subtitle),
                    backgroundColor = OummiEducationCardBg,
                    icon = "📚"
                )
                OummiDashboardActionCard(
                    modifier = Modifier.weight(1f),
                    title = stringResource(R.string.dashboard_communaute_title),
                    subtitle = stringResource(R.string.dashboard_communaute_subtitle),
                    backgroundColor = OummiCommunityCardBg,
                    icon = "👥"
                )
            }
            
            Spacer(modifier = Modifier.height(24.dp))
            
            OummiDailyTipCard()
            
            Spacer(modifier = Modifier.height(24.dp))
            
            OummiSymptomsSection()
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
fun OummiHeader() {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(
                text = stringResource(R.string.dashboard_greeting),
                style = MaterialTheme.typography.bodyMedium,
                color = OummiTextLight
            )
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = stringResource(R.string.dashboard_user_name),
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold,
                    color = OummiTextDark
                )
                Spacer(modifier = Modifier.width(4.dp))
                Text(text = "🌸", fontSize = 20.sp)
            }
        }
        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text(text = "🔔", fontSize = 20.sp)
            }
            Spacer(modifier = Modifier.width(12.dp))
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(OummiAccentColor),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "AK",
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
            }
        }
    }
}

@Composable
fun OummiDashboardActionCard(
    title: String,
    subtitle: String,
    backgroundColor: Color,
    icon: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.height(140.dp),
        colors = CardDefaults.cardColors(containerColor = backgroundColor),
        shape = RoundedCornerShape(20.dp)
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
                    .background(Color.White.copy(alpha = 0.6f)),
                contentAlignment = Alignment.Center
            ) {
                Text(text = icon, fontSize = 20.sp)
            }
            Column {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = OummiTextDark
                )
                Text(
                    text = subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = OummiTextLight
                )
            }
        }
    }
}

@Composable
fun OummiDailyTipCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        shape = RoundedCornerShape(20.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
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
                    color = OummiTextDark
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = stringResource(R.string.dashboard_tip_content),
                    style = MaterialTheme.typography.bodyMedium,
                    color = OummiTextLight,
                    lineHeight = 18.sp
                )
            }
        }
    }
}

@Composable
fun OummiSymptomsSection() {
    Column {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = stringResource(R.string.dashboard_symptoms_title),
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = OummiTextDark
            )
            Text(
                text = stringResource(R.string.dashboard_add_action),
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Bold,
                color = OummiAccentColor
            )
        }
        Spacer(modifier = Modifier.height(12.dp))
        Row(modifier = Modifier.fillMaxWidth()) {
            OummiSymptomChip(text = stringResource(R.string.symptom_cramp), backgroundColor = OummiChipPeach)
            Spacer(modifier = Modifier.width(8.dp))
            OummiSymptomChip(text = stringResource(R.string.symptom_fatigue), backgroundColor = OummiChipPeach)
        }
        Spacer(modifier = Modifier.height(8.dp))
        OummiSymptomChip(text = stringResource(R.string.symptom_mood), backgroundColor = OummiChipGreen)
    }
}

@Composable
fun OummiSymptomChip(text: String, backgroundColor: Color) {
    Surface(
        color = backgroundColor,
        shape = RoundedCornerShape(20.dp),
        border = BorderStroke(1.dp, Color(0xFFF5E1D5).copy(alpha = 0.5f))
    ) {
        Text(
            text = text,
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
            style = MaterialTheme.typography.bodyMedium,
            color = OummiTextDark
        )
    }
}

@Composable
fun OummiBottomNavigation() {
    NavigationBar(
        containerColor = Color.White,
        tonalElevation = 8.dp
    ) {
        val items = listOf(
            Triple(stringResource(R.string.nav_home), "🏠", true),
            Triple(stringResource(R.string.nav_cycle), "❤️", false),
            Triple(stringResource(R.string.nav_calendar), "📅", false),
            Triple(stringResource(R.string.nav_community), "👥", false),
            Triple(stringResource(R.string.nav_profile), "👤", false)
        )
        
        items.forEach { (label, icon, isSelected) ->
            NavigationBarItem(
                selected = isSelected,
                onClick = { },
                icon = { 
                    Text(text = icon, fontSize = 20.sp)
                },
                label = { Text(label, fontSize = 10.sp) },
                colors = NavigationBarItemDefaults.colors(
                    selectedIconColor = OummiNavSelected,
                    selectedTextColor = OummiNavSelected,
                    unselectedIconColor = OummiTextLight,
                    unselectedTextColor = OummiTextLight,
                    indicatorColor = Color.Transparent
                )
            )
        }
    }
}

@Preview(showBackground = true, widthDp = 360)
@Composable
fun OummiDashboardPreview() {
    MaterialTheme {
        OummiDashboard()
    }
}
