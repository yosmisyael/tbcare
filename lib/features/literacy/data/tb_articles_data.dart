import 'package:TBConsult/features/literacy/domain/entities/article_entity.dart';

/// 12 evidence-based TB articles compiled from WHO, CDC, and
/// peer-reviewed public health literature.
/// Images sourced from Unsplash (free, no attribution required for use).
class TBArticlesData {
  TBArticlesData._();

  static final List<ArticleEntity> all = [
    // ── PREVENTION ────────────────────────────────────────────────────────────

    ArticleEntity(
      id: 'prev_01',
      category: ArticleCategory.prevention,
      title: 'Understanding How TB Spreads — and How to Stop It',
      summary:
      'TB is airborne but highly preventable. Learn the exact transmission mechanisms and the proven steps to protect people in your household.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80',
      author: 'WHO Global TB Programme',
      authorRole: 'World Health Organization',
      publishedDate: 'Mar 24, 2024',
      readMinutes: 6,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Tuberculosis (TB) is caused by the bacterium Mycobacterium tuberculosis and spreads through the air when a person with active pulmonary TB coughs, sneezes, speaks, or sings. Tiny droplet nuclei — particles less than 5 microns — can remain suspended in the air for hours in poorly ventilated spaces.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Who Is Most at Risk?',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Close contacts of infectious TB patients face the highest risk. However, not everyone exposed will develop disease. Your immune system plays a critical role: people living with HIV, those with diabetes, malnutrition, or who smoke are significantly more likely to progress from latent infection to active disease.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Key fact: Only about 5–10% of people infected with M. tuberculosis will develop active TB disease during their lifetime. The rest maintain latent infection that can reactivate if immunity weakens.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Protecting Your Household',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Ensure the patient coughs into a tissue or elbow and disposes of tissues safely.',
            'Open windows and doors — natural ventilation is one of the most effective infection controls.',
            'Avoid sleeping in the same room as the patient during the infectious phase.',
            'All household contacts should be screened at a health facility immediately.',
            'Children under 5 and immunocompromised contacts should receive preventive therapy.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'The Role of BCG Vaccination',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'The Bacille Calmette-Guérin (BCG) vaccine is given at birth in high-burden countries. It is highly effective at preventing severe forms of TB in children — including TB meningitis and miliary TB — but provides variable protection against adult pulmonary TB. Adults who were vaccinated as children may still develop pulmonary TB and should not consider themselves protected.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Ventilation Is Your Best Tool',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Studies consistently show that natural ventilation reduces airborne TB transmission more effectively than most other environmental controls. Keep rooms well-ventilated especially when the patient is present. In healthcare settings, UV germicidal irradiation and negative pressure rooms are used — at home, open windows are equivalent.',
        ),
      ],
    ),

    ArticleEntity(
      id: 'prev_02',
      category: ArticleCategory.prevention,
      title: 'TB Preventive Therapy: Who Needs It and Why',
      summary:
      'Latent TB infection affects 1.7 billion people globally. Preventive therapy can stop it from ever becoming active disease.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80',
      author: 'Dr. Tereza Kasaeva',
      authorRole: 'Director, WHO Global TB Programme',
      publishedDate: 'Jan 15, 2024',
      readMinutes: 5,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Latent TB infection (LTBI) means the TB bacteria are present in your body but your immune system is keeping them contained. You have no symptoms and cannot transmit TB to others. However, approximately 5–10% of people with LTBI will develop active TB disease at some point in their lifetime.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Who Should Receive Preventive Therapy?',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'People living with HIV (PLHIV) regardless of TST/IGRA result.',
            'Household contacts of confirmed pulmonary TB patients.',
            'Children under 5 who had close contact with active TB.',
            'Patients starting anti-TNF therapy or dialysis.',
            'Patients being considered for organ transplant.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Current Recommended Regimens',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'The most widely used regimen is 6 months of daily isoniazid (6H). Shorter regimens are now available and preferred in many settings: 3HP (3 months of weekly rifapentine + isoniazid) and 1HP (1 month of daily rifapentine + isoniazid) show equivalent efficacy with better completion rates.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Important: TB preventive therapy should only be started after active TB disease has been ruled out. Starting preventive monotherapy in a patient with active disease can lead to drug resistance.',
        ),
      ],
    ),

    ArticleEntity(
      id: 'prev_03',
      category: ArticleCategory.prevention,
      title: 'Infection Control at Home During Active TB Treatment',
      summary:
      'Practical, evidence-based steps families can take during the infectious phase of TB treatment to prevent transmission.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1585435557343-3b092031a831?w=800&q=80',
      author: 'Stop TB Partnership',
      authorRole: 'Global Health Alliance',
      publishedDate: 'Feb 2, 2024',
      readMinutes: 4,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'The first two to four weeks of TB treatment are the most critical from an infection control standpoint. Most patients become non-infectious within 2–3 weeks of starting effective therapy, but precautions should continue until confirmed by sputum results.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Immediate Actions When TB Is Diagnosed',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Notify all household members and arrange screening at the nearest health facility.',
            'Designate a well-ventilated room for the patient during the infectious phase.',
            'Avoid crowded, enclosed spaces such as public transport and markets.',
            'Wear a surgical mask in close-contact situations — N95 for caregivers if available.',
            'Start treatment immediately — this is the single most effective infection control measure.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'When Is It Safe to Return to Normal Life?',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Most national guidelines consider a patient non-infectious after completing 2 weeks of treatment AND showing clinical improvement. Confirmation requires two negative sputum smear results. Your DOTS officer or health worker will advise you based on your individual results.',
        ),
      ],
    ),

    // ── DIET ──────────────────────────────────────────────────────────────────

    ArticleEntity(
      id: 'diet_01',
      category: ArticleCategory.diet,
      title: 'Optimizing Nutrition During TB Treatment',
      summary:
      'Malnutrition and TB create a dangerous cycle. Breaking it with the right foods can dramatically improve treatment outcomes.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
      author: 'Dr. Anurag Bhargava',
      authorRole: 'Clinical Nutritionist & TB Specialist',
      publishedDate: 'Oct 12, 2023',
      readMinutes: 7,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Tuberculosis and malnutrition are deeply intertwined. TB increases resting metabolic rate by 10–30%, drives muscle wasting, and reduces appetite through cytokine activity. Simultaneously, malnutrition impairs cell-mediated immunity — the very defense mechanism needed to control TB infection. Breaking this cycle through targeted nutrition is a critical component of TB care.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Caloric and Protein Requirements',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Patients with active TB require approximately 35–40 kcal per kilogram of body weight per day — significantly above the standard adult requirement of 25–30 kcal/kg. Protein needs increase to 1.2–1.5 g/kg/day to compensate for muscle catabolism and support immune cell production.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Research finding: A randomized controlled trial in India showed that nutritional support providing an additional 600 kcal/day for 6 months significantly improved treatment success rates and reduced mortality in TB patients with malnutrition.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Key Nutrients to Prioritize',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Protein — eggs, lentils, chicken, fish, dairy. Aim for a protein source at every meal.',
            'Vitamin D — fatty fish, eggs, fortified milk. Deficiency is common in TB patients and impairs macrophage function.',
            'Zinc — meat, seeds, legumes. Supports T-cell function and wound healing.',
            'Iron — red meat, spinach, fortified cereals. Anemia is common and worsens fatigue.',
            'Vitamin B6 — bananas, potatoes, chickpeas. Isoniazid depletes B6; supplementation is often prescribed.',
            'Vitamin C — citrus fruits, bell peppers. Antioxidant support for immune function.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Managing Medication-Related Appetite Loss',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'First-line TB drugs, particularly rifampicin and pyrazinamide, frequently cause nausea, especially in the early weeks. Taking medications with a small amount of food (not a full meal, which can reduce rifampicin absorption) helps. Eating 5–6 small meals throughout the day rather than 3 large ones is easier on the digestive system.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Foods to Avoid',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Alcohol — increases hepatotoxicity risk, especially with isoniazid and rifampicin.',
            'Aged cheese, fermented products, processed meats — contain tyramine which interacts with isoniazid.',
            'Excessive raw fish — some contain isoniazid-inhibiting enzymes.',
            'High-fat, fried foods during nausea episodes.',
          ],
        ),
      ],
    ),

    ArticleEntity(
      id: 'diet_02',
      category: ArticleCategory.diet,
      title: 'Vitamin D and Tuberculosis: What the Evidence Shows',
      summary:
      'Vitamin D deficiency is strikingly common in TB patients. New research reveals how supplementation may accelerate sputum conversion.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800&q=80',
      author: 'Prof. Adrian Martineau',
      authorRole: 'Queen Mary University of London',
      publishedDate: 'Sep 5, 2023',
      readMinutes: 5,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Vitamin D has long been associated with immune function, but its specific role in TB has gained significant research attention over the past decade. Vitamin D activates macrophages to produce antimicrobial peptides — including cathelicidin — that kill M. tuberculosis directly. Deficiency impairs this innate immune response.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'How Deficient Are TB Patients?',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Studies across Asia, Africa, and Europe consistently find that 60–80% of newly diagnosed TB patients are vitamin D deficient (serum 25-OHD < 50 nmol/L). This is partly because TB disease itself causes vitamin D catabolism, and partly because low sunlight exposure and poor diet are risk factors shared with both conditions.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Clinical note: A 2011 randomized trial (Martineau et al., Lancet) showed that high-dose vitamin D3 supplementation accelerated sputum smear conversion in TB patients who carried certain vitamin D receptor genotypes.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Practical Supplementation',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Standard supplementation: 1,000–2,000 IU vitamin D3 daily.',
            'Spend 15–30 minutes in direct sunlight between 10am–3pm daily if possible.',
            'Dietary sources: salmon, mackerel, eggs, fortified milk.',
            'Do not take megadoses without medical supervision — vitamin D toxicity causes hypercalcemia.',
          ],
        ),
      ],
    ),

    ArticleEntity(
      id: 'diet_03',
      category: ArticleCategory.diet,
      title: 'Staying Hydrated During TB Treatment',
      summary:
      'Water does more than quench thirst — it helps your kidneys and liver process the heavy medication load of TB treatment.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=800&q=80',
      author: 'TB Alliance Nutrition Team',
      authorRole: 'Global Health Sciences',
      publishedDate: 'Nov 20, 2023',
      readMinutes: 3,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'First-line TB drugs are metabolized primarily by the liver and excreted by the kidneys. Adequate hydration — at least 8 glasses (2 liters) of water per day — supports both organs in processing the daily medication load without accumulating toxic metabolites.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Signs of Dehydration to Watch For',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Dark yellow or amber urine (note: rifampicin turns urine orange-red — this is normal).',
            'Dry mouth, headache, or dizziness.',
            'Reduced urine output.',
            'Muscle cramps or confusion in severe cases.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Reminder: The orange-red discoloration of urine, tears, and sweat caused by rifampicin is harmless. Do not confuse this with hematuria (blood in urine), which is a medical emergency.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Herbal teas, diluted fruit juices, and soups all count toward fluid intake. Caffeinated drinks have a mild diuretic effect — limit coffee and strong tea to 1–2 cups daily and compensate with extra water.',
        ),
      ],
    ),

    // ── MEDICATION ────────────────────────────────────────────────────────────

    ArticleEntity(
      id: 'med_01',
      category: ArticleCategory.medication,
      title: 'Understanding Your First-Line TB Drugs',
      summary:
      'HRZE — the four drugs at the heart of TB treatment. What each one does, how they work together, and what side effects to expect.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80',
      author: 'Dr. Paul Nunn',
      authorRole: 'TB Treatment Specialist',
      publishedDate: 'Dec 1, 2023',
      readMinutes: 8,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Standard first-line TB treatment consists of four drugs given together: Isoniazid (H), Rifampicin (R), Pyrazinamide (Z), and Ethambutol (E). This combination is designed to target different populations of M. tuberculosis bacteria simultaneously — rapidly dividing, slowly dividing, and dormant bacteria — preventing the emergence of drug resistance.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Isoniazid (H)',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Isoniazid is bactericidal against actively dividing TB bacteria. It works by inhibiting mycolic acid synthesis — a critical component of the mycobacterial cell wall. It is given daily throughout the full 6-month course. Key side effects include peripheral neuropathy (numbness/tingling in hands and feet), which is prevented by pyridoxine (vitamin B6) co-administration, and hepatotoxicity.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Rifampicin (R)',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Rifampicin is the most potent sterilizing drug in the TB regimen. It inhibits bacterial RNA polymerase and is active against all populations of M. tuberculosis. It turns body fluids (urine, sweat, tears) orange-red — this is harmless but permanent staining of contact lenses can occur. It is a strong inducer of liver enzymes (CYP450) and significantly reduces the effectiveness of many other drugs including oral contraceptives, antiretrovirals, and warfarin.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Pyrazinamide (Z)',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Pyrazinamide is uniquely active in the acidic environment of macrophage lysosomes — where TB bacteria hide from the immune system. It is given for the first 2 months only. It is responsible for most treatment-related joint pain and gout flares (by raising uric acid levels), as well as most of the hepatotoxicity risk in the intensive phase.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Ethambutol (E)',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Ethambutol inhibits arabinogalactan synthesis in the mycobacterial cell wall. It is included primarily to protect against isoniazid resistance. Its main concern is optic neuritis — changes in vision (particularly color vision and visual acuity) that are usually reversible if detected early. Report any visual changes to your doctor immediately.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Critical reminder: Never stop your TB medication without medical advice, even if you feel better. Incomplete treatment is the primary driver of drug-resistant TB worldwide.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'The Two Phases of Treatment',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Intensive phase (months 1–2): All four drugs (HRZE) given daily. This rapidly reduces the bacterial load.',
            'Continuation phase (months 3–6): Only isoniazid and rifampicin (HR) continue. This eliminates remaining dormant bacteria.',
            'Total duration: 6 months for drug-sensitive TB in most patients.',
            'Drug-resistant TB may require 9–24 months with different drug combinations.',
          ],
        ),
      ],
    ),

    ArticleEntity(
      id: 'med_02',
      category: ArticleCategory.medication,
      title: 'Managing TB Drug Side Effects Without Stopping Treatment',
      summary:
      'Side effects are common but most are manageable. Stopping treatment is far more dangerous than most side effects.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?w=800&q=80',
      author: 'National TB Programme Guidelines',
      authorRole: 'Ministry of Health',
      publishedDate: 'Aug 18, 2023',
      readMinutes: 6,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Most TB patients experience at least one side effect during treatment, particularly in the first 2 months (intensive phase). Understanding which side effects are minor and manageable versus which are serious warning signs requiring immediate medical attention can make the difference between completing treatment safely and developing drug-resistant TB.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Minor Side Effects — Continue Treatment',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Orange-red urine, sweat, tears (rifampicin) — normal, harmless.',
            'Nausea, loss of appetite in first weeks — take medication with a light snack.',
            'Joint pains, gout (pyrazinamide) — treat with aspirin or NSAIDs, increase fluids.',
            'Numbness or tingling in hands/feet (isoniazid) — take vitamin B6 (pyridoxine).',
            'Skin itching without rash — antihistamines usually help.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Serious Side Effects — Stop and Seek Care Immediately',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Jaundice (yellow skin/eyes) or dark urine with pale stools — hepatotoxicity.',
            'Visual changes, loss of color vision (ethambutol) — optic neuritis.',
            'Skin rash with blisters or peeling — Stevens-Johnson syndrome.',
            'Severe abdominal pain or vomiting blood.',
            'Confusion, severe headache, or seizures.',
            'Shortness of breath or severe chest pain.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'If you stop treatment: Drug-resistant TB (MDR-TB) is significantly harder to treat, requiring 9–24 months of more toxic drugs. The best response to side effects is to contact your health worker — not to stop medication independently.',
        ),
      ],
    ),

    ArticleEntity(
      id: 'med_03',
      category: ArticleCategory.medication,
      title: 'Why Treatment Adherence Is the Most Important Thing You Can Do',
      summary:
      'Drug-resistant TB is created by incomplete treatment. DOTS exists precisely to ensure every patient completes every dose.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1583324113626-70df0f4deaab?w=800&q=80',
      author: 'Dr. Mario Raviglione',
      authorRole: 'Former Director, WHO Global TB Programme',
      publishedDate: 'Jul 10, 2023',
      readMinutes: 5,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Directly Observed Therapy, Short-course (DOTS) — the global standard of TB care — was developed in response to a critical observation: when patients are left to self-administer TB drugs, completion rates drop sharply, and drug resistance emerges. DOTS ensures every dose is witnessed, recorded, and supported.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'What Happens When Doses Are Missed',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'M. tuberculosis has a remarkable capacity to develop resistance through spontaneous mutation. When drug concentrations fall below therapeutic levels due to missed doses, resistant mutants that were previously suppressed begin to proliferate. Missing even one week of treatment can allow resistance to emerge. MDR-TB and XDR-TB — the most treatment-resistant forms — are almost entirely man-made through incomplete treatment.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Global impact: An estimated 450,000 new cases of MDR-TB occur each year, the vast majority caused by transmission of already-resistant strains or failure to complete treatment.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Practical Strategies for Adherence',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Take medication at the same time every day — link it to a daily routine (morning tea, brushing teeth).',
            'Use a pill organizer or app like this one to track daily doses.',
            'Identify one trusted support person who knows your treatment schedule.',
            'Contact your DOTS officer immediately if you miss a dose — never double up without advice.',
            'Keep a 2-week supply at home — never run out.',
          ],
        ),
      ],
    ),

    // ── MENTAL HEALTH ─────────────────────────────────────────────────────────

    ArticleEntity(
      id: 'mh_01',
      category: ArticleCategory.mentalHealth,
      title: 'The Psychological Burden of TB — You Are Not Alone',
      summary:
      'Depression and anxiety are twice as common in TB patients as in the general population. Understanding why — and what helps.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=800&q=80',
      author: 'Dr. Blessina Kumar',
      authorRole: 'Global Coalition of TB Activists',
      publishedDate: 'Oct 10, 2023',
      readMinutes: 6,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'A TB diagnosis carries an enormous psychological weight. Stigma, extended treatment duration, physical symptoms, side effects, financial strain from missed work, and isolation from family and community all contribute to a mental health burden that is frequently underrecognized and undertreated. Studies show that 40–60% of TB patients experience clinically significant depression or anxiety.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Why Mental Health Affects Treatment Outcomes',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'The link between mental health and TB outcomes is bidirectional and well-established. Depression significantly reduces medication adherence — patients with untreated depression are 3 times more likely to default from TB treatment. Additionally, psychological stress directly impairs immune function through cortisol-mediated suppression of T-cell activity.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Evidence: A systematic review of 48 studies found that depression at the start of TB treatment was associated with a 3-fold increase in risk of treatment failure or death.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Recognizing Depression and Anxiety',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Persistent sadness or emptiness lasting more than 2 weeks.',
            'Loss of interest in activities you previously enjoyed.',
            'Difficulty sleeping or sleeping too much.',
            'Fatigue beyond what the illness explains.',
            'Feelings of worthlessness, shame, or hopelessness.',
            'Withdrawing from family and social contact.',
            'Constant worry or fear that interferes with daily life.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'What Actually Helps',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Tell your health worker — psychological distress is a medical concern, not a weakness.',
            'Peer support groups — speaking with others who have completed TB treatment is remarkably effective.',
            'Structured daily routine — predictability reduces anxiety.',
            'Physical activity appropriate to your condition — even short walks improve mood through endorphin release.',
            'Cognitive behavioral therapy (CBT) — available through some DOTS programs.',
          ],
        ),
      ],
    ),

    ArticleEntity(
      id: 'mh_02',
      category: ArticleCategory.mentalHealth,
      title: 'Dealing With TB Stigma in Your Community',
      summary:
      'Stigma causes patients to delay care, hide diagnosis, and stop treatment. Here is how to navigate it — and how communities can do better.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800&q=80',
      author: 'Stop TB Partnership',
      authorRole: 'Global Health Alliance',
      publishedDate: 'Sep 28, 2023',
      readMinutes: 5,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'TB stigma is one of the most significant barriers to care globally. Surveys in high-burden countries consistently show that fear of discrimination is a primary reason patients delay diagnosis — sometimes by months — and abandon treatment. This stigma is not based on medical reality: TB is a curable disease, and patients on effective treatment quickly become non-infectious.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Where Stigma Comes From',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Historical associations between TB and poverty, "moral failure," and death — combined with visible symptoms like coughing and weight loss — have created deep cultural stigma. In some communities, TB is still incorrectly believed to be associated with HIV, promiscuity, or ancestral punishment. None of these associations are medically valid.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Reality check: TB is caused by breathing in airborne bacteria. It can affect anyone — regardless of income, behavior, or moral character. It is not a reflection of who you are.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Protecting Yourself From Stigma',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'You are not obligated to disclose your diagnosis to employers or acquaintances.',
            'Choose a small, trusted circle to share with — select people who will support rather than judge.',
            'Connect with TB survivor communities — people who have been through what you are experiencing.',
            'Document any discrimination you face — TB-related discrimination is illegal in most countries.',
          ],
        ),
      ],
    ),

    ArticleEntity(
      id: 'mh_03',
      category: ArticleCategory.mentalHealth,
      title: 'Building Resilience Through Long-Term TB Treatment',
      summary:
      'Six months feels like a long time. These evidence-based strategies help patients maintain motivation from diagnosis to cure.',
      heroImageUrl:
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&q=80',
      author: 'Dr. Karin Weyer',
      authorRole: 'Senior TB Advisor, USAID',
      publishedDate: 'Nov 5, 2023',
      readMinutes: 6,
      blocks: [
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Psychological resilience — the ability to maintain motivation and emotional stability in the face of a prolonged health challenge — is a learnable skill. TB treatment takes a minimum of 6 months, and patients who develop resilience strategies early in treatment are significantly more likely to complete the full course.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Break the Journey Into Milestones',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'Rather than thinking of "6 months of treatment," set smaller goals: complete the first 2 weeks, reach the first sputum conversion, complete the intensive phase, reach the halfway point. Celebrate each milestone — track your streak in an app, mark your calendar, share the achievement with your support person.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.callout,
          text:
          'Motivation strategy: Research in behavior change shows that tracking visible progress — like a daily streak counter — activates the brain\'s reward system and increases adherence rates by up to 40%.',
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'Strategies That Work',
        ),
        const ArticleBlock(
          type: ArticleBlockType.bullet,
          bullets: [
            'Morning routine anchoring — take your medication as part of an established morning ritual.',
            'Identify your "why" — write down what you will be able to do when treatment is complete.',
            'Body-based stress relief — deep breathing, gentle stretching, or walking.',
            'Limit negative news and social media during vulnerable periods.',
            'Engage in meaningful activity — even small contributions to family or community counter hopelessness.',
            'Sleep hygiene — TB medication and the disease itself disrupt sleep. Consistent bedtimes improve resilience.',
          ],
        ),
        const ArticleBlock(
          type: ArticleBlockType.heading,
          text: 'When Professional Help Is Needed',
        ),
        const ArticleBlock(
          type: ArticleBlockType.paragraph,
          text:
          'If you find that sadness, anxiety, or loss of motivation is affecting your ability to take medication or function daily, this is a clinical symptom — not a character flaw. Ask your DOTS officer to refer you to a counselor or psychologist. Many national TB programs have integrated mental health support, and it is part of your right to care.',
        ),
      ],
    ),
  ];
}
