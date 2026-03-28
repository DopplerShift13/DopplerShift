import { Box, Button, Collapsible, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Powers } from './PowersMenu';
import type { PreferencesMenuData } from './types';

type ResonantPowerProps = {
  handleCloseResonant: () => void;
};
export const ResonantPage = (props: ResonantPowerProps) => {
  const { data } = useBackend<PreferencesMenuData>();
  const descriptionBlock = (text: string) => (
    <Collapsible title="Mechanics" color="transparent" mt={0.5}>
      <Box style={{ whiteSpace: 'pre-line' }}>{text}</Box>
    </Collapsible>
  );
  return (
    <Stack vertical>
      <Stack.Item>
        <Button icon="arrow-left" onClick={props.handleCloseResonant}>
          Go Back
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Section
          align="center"
          title={'Points: ' + data.power_points + '/' + data.total_power_points}
        >
          <Button
            icon="crown"
            tooltip="Powers with this icon are root powers. They unlock access to powers in a specific path."
            color="transparent"
          />
          <Button
            icon="diamond"
            tooltip="Powers with this icon are advanced powers. They cannot be picked with other paths."
            color="transparent"
          />
          <br />
          Hover over the learn button to view the required root power, if
          applicable.
        </Section>
      </Stack.Item>
      <Stack.Item />
      <Stack>
        <Stack.Item minWidth="33%">
          <Section title="Psyker">
            {descriptionBlock(
              'The mind grows stronger, and your body twisted to facilitate it, as much as it can handle. Psykers uses classically psychic abilities such as telekenisis and telepathy, mastering the domain over the mind.\
              \n\nMechanically, this manifests in their special mechanic; Stress. You have an unique organ inside you called a Paracusal Gland. This is in-essence the liver of your brain; it is there to handle chemical and physical strain put on your body by your mental powers.\
              Using your powers generates Stress proportional to the impact of your powers. Whilst you are under the Stress Threshold, it passively diminishes over-time, but should you go over it, you start experiencing negative events and your stress will not decay without using\
              the special Meditate action you were given. You are never truly certain of how much Stress you have, only the estimates given by your body violently reacting to the pressure.\
              \n\nExceeding the threshold causes at first mild symptons, such as headaches, jittering and more. Continued overuse expands it to severe symptoms such as bleeding eyes, vomiting and more. Should you continue past this point, you will suffer a\
              catastrophic breakdown, often inflicting permanent, long-lasting injuries on you, and reseting your Stress consequently.\
              \n\nIn exchange for this Stress, almost none of your abilities have cooldowns or other limiting factors; Stress is your sole-limiting resource. Manage it well.',
            )}
            <Stack vertical>
              {data.psyker.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item minWidth="33%">
          <Section title="Cultivator">
            {descriptionBlock(
              "Your body is a temple; one that strengthens from aligning it with resonant energies. By associating with specific phenomena, you gain supernatural powers, allowing you resist blows and strike with your fists as if it were a blade.\
              \n\nCultivator builds up a resource called Energy, which is the cost for a variety of their powers. Most prominently it is used to fuel a state called Alignment. Once you enter this heightened state of Alignment, you gain passive effects and heightened damage,\
              turning you into a force to be reckoned with regardless of your current equipment. Many of your powers require Alignment to be active and cost Energy in turn, but have some incredibly powerful effects in turn.\
              \n\nEnergy is build up through two methods; Meditation, and Aura. Meditation can be done at any point, engulfing you in light as you attune with the passive Resonance in the air. This slowly fills your energy, but prevents you from doing anything else.\
              Meanwhile, Aura lets you harvest it passively from an environment with which you align. If your Alignment is Astral Touched, that means your Energy builds from seeing starlight and other space-based phenomena, whilst something such as Flame soul energizes from seeing exposed flames.\
              You can combine these two methods; an Astral-Touched Cultivator energizes quickly while meditating before the stars. Your Energy caps out at 1000, and most Alignments require at least 200 to activate, with a hefty upkeep (you cannot gain Energy while in Alignment).\
              \n\nYou won't be able to enter your heightened state often, but once you do, you will wield great powers. Wisdom is knowing when to wield it.",
            )}
            <Stack vertical>
              {data.cultivator.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item minWidth="33%">
          <Section title="Aberrant">
            {descriptionBlock(
              "Aberrant is a collection of the odd, the excentric and the extraordinary. It is home to many categories, of various capabilities that don't belong strongly in any particular path. These three categories are:\
              \n\nBeastial; people who have the trait and qualities of animals. Whether being able to shift into one, or mimmicking their biological traits, they wield these along with their existing biology to enhance their capabilities.\
              Beastial abilities often have a hunger cost and cannot be used while starving.\
              \n\nAberrant; whose traits are not of animals, but of monsters. The ability to regenerate any wounds, to grow blades for arms. The qualities of monsters that are often the tail of rumor and folk-lore. They often resist any and all\
              harm cast upon them; and often are the truly unstopable monsters people think about.\
              \n\nAnomalous; whose very existence is unexplainable through sciences. The ability to end anomalies at a touch, the ability to walk through rifts in realities, or interacting in inexplicable ways with reality, such as healing from radiation poisoning.\
              These oddities work in their own way, and wield their poorly understood powers in their day-to-day work.",
            )}
            <Stack vertical>
              {data.aberrant.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Stack>
  );
};
