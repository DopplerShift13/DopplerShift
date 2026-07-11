/*
  This houses most of the 'per category' snowflake stuff that's different per section. PowerPathPage.tsx communicates and gets the appropriate content from here.
  Any 'snowflake' additions that are path specific should use this page.
*/

import type { PowerPathId } from './types';

export type PowerPathFamilyId = 'sorcerous' | 'resonant' | 'mortal';

export type PowerPathConfig = {
  displayName: string;
  familyId: PowerPathFamilyId;
  iconAssetName?: string;
  isAvailable: boolean;
  mechanicsText: string;
  overviewText: string;
  themeColor: string;
};

export type PowerPathFamilyConfig = {
  pathIds: PowerPathId[];
  title: string;
};

export const powerPathFamilies: PowerPathFamilyConfig[] = [
  {
    pathIds: ['thaumaturge', 'theologist'],
    title: 'Sorcerous',
  },
  {
    pathIds: ['psyker', 'cultivator', 'aberrant', 'imbued'],
    title: 'Resonant',
  },
  {
    pathIds: ['warfighter', 'expert', 'augmented', 'irregular'],
    title: 'Mortal',
  },
];

export const defaultPowerPathId: PowerPathId = 'thaumaturge';

export const powerPathConfig: Record<PowerPathId, PowerPathConfig> = {
  thaumaturge: {
    displayName: 'Thaumaturge',
    familyId: 'sorcerous',
    iconAssetName: 'thaumaturgeicon.png',
    isAvailable: true,
    mechanicsText:
      "Thaumaturgy has two core components; Spell Preperation, and Affinity.\n\nTo start off, your spells are limited not by cooldowns, but by charges. Every point you put in the Thaumaturge power grants you 2 points of Mana. This is used by your Spell Preperation power, which allows you to allocate your Mana to spells to charge them. The cost to gain the Power is the same as to prepare the Charges. Once you set your spells, that are the amount of charges you have. Once you run out of charges, you can't use that power again until you sleep for a certain duration. Not just any sleep will do; you need a catalyst on you to shape your dreams called an Arcane Focus. You start the round with it, and you'd best keep it safe, as without it you won't ever be able to restore your spells.\n\nFuthermore, you have Affinity to both scale and use your powers. Your Arcane Focus has a value called Affinity, which determines the potency of your spells. Some spells require a certain amount of affinity to wield; and you gain it by holding the affinity item. Exceeding the required affinity usually grants additional bonuses with spells, such as higher damage (elaborated per spell). Affinity also exists on other items and clothes; dressing like a Wizard with a wizard costume will grant you Affinity as well. Affinity does not stack; you take the highest source. You can examine items to see how much Affinity they have, if any. Usually anything you'd see on a druid, wizard, bard or other magically inclined person in folklore will grant you Affinity.",
    overviewText:
      "Magic, wizards, sages. The most classical depiction of magic in folklore and history is based on perception, and people's believe that a person with a pointy-hat can cast a spell. To be a Thaumaturge, you have to act like a Thaumaturge.",
    themeColor: '#7266dd',
  },
  enigmatist: {
    displayName: 'Enigmatist',
    familyId: 'sorcerous',
    iconAssetName: undefined,
    isAvailable: false,
    mechanicsText:
      'POWERS UNREACHABLE BY YOUR WEAK HANDS, NUANCE UNCOMPREHENDABLE BY YOUR FEEBLE MIND, HORRORS THAT SOON WILL BE UNDERSTOOD BY YOUR FRAIL BODY',
    overviewText: 'INTERLOPER, THIS IS NOT YOUR REALM TO ENTER. NOT YET!',
    themeColor: '#439c27',
  },
  theologist: {
    displayName: 'Theologist',
    familyId: 'sorcerous',
    iconAssetName: 'theologisticon.png',
    isAvailable: true,
    mechanicsText:
      'Theologists are spread across several categories, each of which have a base power that heals the wounds of others. In what form and with what method differs per power, but it will always grant you a measure of Piety.\n\nPiety is a measure of your good deeds; it is gained by healing others with your powers, proportional to the healing (as long as it is sentient, healing animals is not pious, alas). These are in turn used to fuel other theologist powers, such as being able to bless weapons, randomly resist blows and other powers specific to your path. It has a maximum of 50.\n\nUniquely, the Chaplain gains additional powers and bonuses with certain powers, and has double the maximum amount of Piety. Theologist powers and not necessairly related to divinity; they are rooted in firm believe themselves, whether in said divinity or their deeds.',
    overviewText:
      'Whilst Thaumaturgy is rooted in the perception of others on you, Theology is rooted in your perception of self. To act holy and perform miracles is rooted in firm believe and willpower.',
    themeColor: '#d1c029',
  },
  psyker: {
    displayName: 'Psyker',
    familyId: 'resonant',
    iconAssetName: 'psykericon.png',
    isAvailable: true,
    mechanicsText:
      'Your special mechanic is called Stress. You have an unique organ inside you called a Paracusal Gland. This is in-essence the liver of your brain; it is there to handle chemical and physical strain put on your body by your mental powers.\nUsing your powers generates Stress proportional to the impact of your powers. Whilst you are under the Stress Threshold, it passively diminishes over-time, but should you go over it, you start experiencing negative events and your stress will not decay without using the special Meditate action you were given (or other abilities, depending on your root power). You are never truly certain of how much Stress you have, only the estimates given by your body violently reacting to the pressure.\n\nExceeding the threshold causes at first mild symptons, such as headaches, jittering and more. Continued overuse expands it to severe symptoms such as bleeding eyes, vomiting and more. Should you continue past this point, you will suffer a catastrophic breakdown, often inflicting permanent, long-lasting injuries on you, and reseting your Stress consequently.\n\nIn exchange for this Stress, almost none of your abilities have cooldowns or other limiting factors; Stress is your sole-limiting resource. Manage it well.',
    overviewText:
      'The mind grows stronger, and your body twisted to facilitate it, as much as it can handle. Psykers uses classically psychic abilities such as telekenisis and telepathy, mastering the domain over the mind.',
    themeColor: '#b94398',
  },
  cultivator: {
    displayName: 'Cultivator',
    familyId: 'resonant',
    iconAssetName: 'cultivatoricon.png',
    isAvailable: true,
    mechanicsText:
      "Cultivator revolves around a resource they build up called Energy, which is the cost for a variety of their powers. Most prominently it is used to fuel a state called Alignment. Once you enter this heightened state of Alignment, you gain passive effects and heightened damage, turning you into a force to be reckoned with regardless of your current equipment. Many of your powers require Alignment to be active and cost Energy in turn, but have some incredibly powerful effects in turn.\n\nEnergy is build up through two methods; Meditation, and Aura. Meditation can be done at any point, engulfing you in light as you attune with the passive Resonance in the air. This slowly fills your energy, but prevents you from doing anything else. Meanwhile, Aura lets you harvest it passively from an environment with which you align. If your Alignment is Astral Touched, that means your Energy builds from seeing starlight and other space-based phenomena, whilst something such as Flame soul energizes from seeing exposed flames. You can combine these two methods; an Astral-Touched Cultivator energizes quickly while meditating before the stars. Your Energy caps out at 1000, and most Alignments require at least 200 to activate, with a hefty upkeep (you cannot gain Energy while in Alignment).\n\nYou won't be able to enter your heightened state often, but once you do, you will wield great powers. Wisdom is knowing when to wield it.",
    overviewText:
      'Your body is a temple; one that strengthens from aligning it with resonant energies. By associating with specific phenomena, you gain supernatural powers, allowing you resist blows like a mountain, and strike with your fists as if it were a blade.',
    themeColor: '#66c5dd',
  },
  aberrant: {
    displayName: 'Aberrant',
    familyId: 'resonant',
    iconAssetName: 'aberranticon.png',
    isAvailable: true,
    mechanicsText:
      "Aberrant specializes in adjusting their physical qualities to mimmick various other creatures, granting them unique physical advantages, both big and small.\n\nNearly all your abilities impact your hunger, increasing it with their use. If you have an alternative stomach, such as by being an Ethereal, it will deduct that stomach's satiety equivelant instead. Make sure to match your strength with a voracious apetite, as nearly all your powers cannot be activated while starving (and passive powers will stop functioning then). Your powers are sometimes non-magical. \n\nBeastial; people who have the trait and qualities of animals. Whether being able to shift into one, or mimmicking their biological traits, they wield these along with their existing biology to enhance their capabilities. Most powers belonging to Beastial are oriented towards utility, rather than raw offensive force.\n\nAberrant; whose traits are not of animals, but of monsters. The ability to regenerate any wounds, to grow blades for arms. The qualities of monsters that are often the tail of rumor and folk-lore. They often resist any and all harm cast upon them; and often are the truly unstopable monsters people think about. Aberrant focuses on strong combat prowress, both in high defense and offense.",
    overviewText:
      'The body altered and twisted. Exposure to resonance has exposed them to atavism, morphing their bodies to take on beastial traits, or sometimes even monstrous ones.',
    themeColor: '#4F3A57',
  },
  imbued: {
    displayName: 'Imbued',
    familyId: 'resonant',
    iconAssetName: 'imbuedicon.png',
    isAvailable: true,
    mechanicsText:
      'Imbued applies largely passive effects to the owner, often adding strange and unusual interactions which require smarts and circumstance to wield effectively. \n\nAnomalous are supernatural effects unexpleinable by sciences but not magical. The ability to end anomalies at a touch, the ability to walk through rifts in realities, or interacting in inexplicable ways with reality, such as healing from radiation poisoning. There is no larger overarching mechanics; use each tool wisely. \nPowers from this category are not affected by antimagic!\n\nEnchanted creatures are more in-touch with magic. Their body interacts with magic phenomena, often having gimmicky, unusual qualities to them, or having enhanced effect when combined with other magical archetypes. Whilst it has no larger overarching mechanics, it often has synergies with other powers.',
    overviewText:
      'Whether resonant or anomalous, the Imbued have had how they interact with the world altered forever. They disobey the laws of science, even as their body remains the same.',
    themeColor: '#e9874f',
  },
  warfighter: {
    displayName: 'Warfighter',
    familyId: 'mortal',
    iconAssetName: 'warfightericon.png',
    isAvailable: true,
    mechanicsText:
      'Warfighter, as the name implies, focuses almost exclusively on combat. It is split into three distinct categories, which are not mutually exclusive.\n\nCommander, which applies defensive buffs to targets through verbal or non-verbal command. The efficiency of these powers scales with whether the target is in your department and if you are a leadership role.\n\nEquipment Specialist, which specializes in using specific equipment in better ways. These usually require a specific type of item to get their mileage out of it, but some are more universally applicable than others, such as dual-wielding.\n\nMartial Artist, which powers up your unarmed prowess and grants you better strikes, access to martial arts and tackling.',
    overviewText:
      "Practical combat skills, tried, tested and trained for milennia before magic ever reared its head. They may throw fireballs: but what good are their feats of magic if they're already tackled and restrained to the ground?",
    themeColor: '#ac2222',
  },
  expert: {
    displayName: 'Expert',
    familyId: 'mortal',
    iconAssetName: 'experticon.png',
    isAvailable: true,
    mechanicsText:
      'There are no broader mechanics in Expert. Most expert powers provide specialized bonuses that on their own may seem niche, but when presented with their use-case, can help you perform your actions come to fruition. An expert is only as good as their creativity.',
    overviewText:
      'Experts are broad in their capabilities, and often include the many phenomenal things anyone can do with perseverance, experience and a fair degree of luck',
    themeColor: '#38495C',
  },
  augmented: {
    displayName: 'Augmented',
    familyId: 'mortal',
    iconAssetName: 'augmentedicon.png',
    isAvailable: true,
    mechanicsText:
      'Augmented grants you augments at round-start, but is is beholden to a fair few restrictions and drawbacks; you can only have one augment per body part, and you are susceptible to EMPs, disabling your augments and possibly having adverse side-effects.\n\nA subcategory of powers exists within Augmented; Premium Augments. These are commercialized and specialized augments made out of propieretary parts, making them unable to be built on the station. These possess a quality meter, which dictates how much mileage you get out of your Premium Augments. The higher the percentage, the stronger their effects. Through robotic surgery, these can be maintained and refurbished, restoring their quality. Once quality reaches 0%, you are required to refurbish it for it to be functional.\nWhether you wish to burn through your augments and make repeat roboticist visits, or try to be more diligent with it, is up to you. Keep in mind as well; your powers can be physically stolen!',
    overviewText:
      'The flesh is weak; Augmented lets you tweak and adjust your physical body with specialized augments, granting you capabilities on-par with resonance, in a technological manner.',
    themeColor: '#6b6652',
  },
  irregular: {
    displayName: 'Irregular',
    familyId: 'mortal',
    iconAssetName: 'irregularicon.png',
    isAvailable: true,
    mechanicsText:
      'Irregular does not count against the 2-paths only limit. In turn, all powers in Irregular provide niché benefits only, and often only at payoffs (for example, records-manipulating powers could be seen as fraud). There are no other overarching mechanics.',
    overviewText:
      'A catch-all for niche qualities that make you stand out, but are not great feats worth boasting about.',
    themeColor: '#cacaca',
  },
};
