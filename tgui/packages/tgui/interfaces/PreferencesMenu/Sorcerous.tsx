import { Box, Button, Collapsible, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Powers } from './PowersMenu';
import type { PreferencesMenuData } from './types';

type SorcerousPageProps = {
  handleCloseSorcerous: () => void;
};

export const SorcerousPage = (props: SorcerousPageProps) => {
  const { data } = useBackend<PreferencesMenuData>();
  const descriptionBlock = (text: string) => (
    <Collapsible title="Mechanics" color="transparent" mt={0.5}>
      <Box style={{ whiteSpace: 'pre-line' }}>{text}</Box>
    </Collapsible>
  );
  return (
    <Stack vertical>
      <Stack.Item>
        <Button icon="arrow-left" onClick={props.handleCloseSorcerous}>
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
          <Section title="Thamaturge">
            {descriptionBlock(
              "Magic, wizards, sages. The most classical depiction of magic in folklore and history is based on perception, and people's believe that a person with a pointy-hat can cast a spell. To be a Thaumaturge, you have to act like a Thaumaturge.\
              \nThaumaturgy has two core components; Spell Preperation, and Affinity.\
              \n\nTo start off, your spells are limited not by cooldowns, but by charges. Every point you put in the Thaumaturge power grants you 2 points of Mana. This is used by your Spell Preperation power, which allows you to allocate\
              your Mana to spells to charge them. The cost to gain the Power is the same as to prepare the Charges. Once you set your spells, that are the amount of charges you have. Once you run out of charges, you can't use \
              that power again until you sleep for a certain duration. Not just any sleep will do; you need a catalyst on you to shape your dreams called an Arcane Focus. You start the round with it, and you'd best keep it safe, as without\
              it you won't ever be able to restore your spells.\
              \n\nFuthermore, you have Affinity to both scale and use your powers. Your Arcane Focus has a value called Affinity, which determines the potency of your spells. Some spells require a certain amount of affinity to wield;\
              and you gain it by holding the affinity item. Exceeding the required affinity usually grants additional bonuses with spells, such as higher damage (elaborated per spell). Affinity also exists on other items and clothes; \
              dressing like a Wizard with a wizard costume will grant you Affinity as well. Affinity does not stack; you take the highest source. You can examine items to see how much Affinity they have, if any. Usually anything \
              you'd see on a druid, wizard, bard or other magically inclined person in folklore will grant you Affinity.",
            )}
            <Stack vertical>
              {data.thaumaturge.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item minWidth="33%">
          <Section title="Enigmatist">
            {descriptionBlock('Enigmatist is still in development!')}
            <Stack vertical>
              {data.enigmatist.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item minWidth="33%">
          <Section title="Theologist">
            {descriptionBlock(
              'Whilst Thaumaturgy is rooted in the perception of others on you, Theology is rooted in your perception of self. To act holy and perform miracles is rooted in firm believe and willpower.\
            \nTheologists are spread across several categories, each of which have a base power that heals the wounds of others. In what form and with what method differs per power, but it will always grant you a measure of Piety.\
            \n\nPiety is a measure of your good deeds; it is gained by healing others with your powers, proportional to the healing (as long as it is sentient, healing animals is not pious, alas). These are in turn used to fuel other\
            theologist powers, such as being able to bless weapons, randomly resist blows and other powers specific to your path. It has a maximum of 50.\
            \n\nUniquely, the Chaplain gains additional powers and bonuses with certain powers, and has double the maximum amount of Piety. Theologist powers and not necessairly related to divinity; they are rooted in firm believe themselves, whether in said divinity or their deeds.',
            )}
            <Stack vertical>
              {data.theologist.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Stack>
  );
};
