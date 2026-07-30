import { Box, Button, Collapsible, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Powers } from './PowersMenu';
import type { PreferencesMenuData } from './types';

type MortalPagePowers = {
  handleCloseMortal: () => void;
};

export const MortalPage = (props: MortalPagePowers) => {
  const { data } = useBackend<PreferencesMenuData>();
  const descriptionBlock = (text: string) => (
    <Collapsible title="Mechanics" color="transparent" mt={0.5}>
      <Box style={{ whiteSpace: 'pre-line' }}>{text}</Box>
    </Collapsible>
  );
  return (
    <Stack vertical>
      <Stack.Item>
        <Button icon="arrow-left" onClick={props.handleCloseMortal}>
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
          <Section title="Warfighter">
            {descriptionBlock(
              'Warfighter, as the name implies, focuses almost exclusively on combat. It is split into three distinct categories, which are not mutually exclusive.\
              \n\nCommander, which applies defensive buffs to targets through verbal or non-verbal command. The efficiency of these powers scales with whether the target is in your department and if you are a leadership role.\
              \n\nEquipment Specialist, which specializes in using specific equipment in better ways. These usually require a specific type of item to get their mileage out of it, but some are more universally applicable than others, such as dual-wielding.\
              \n\nMartial Artist, which powers up your unarmed prowess and grants you better strikes, access to martial arts and tackling.',
            )}
            <Stack vertical>
              {data.warfighter.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item minWidth="33%">
          <Section title="Expert">
            {descriptionBlock(
              'Experts are broad in their capabilities, and often include the many phenomenal things anyone can do with perseverance, experience and a fair degree of luck. There are no broader mechanics in Expert.\
              \n\nMost expert powers provide specialized bonuses that on their own may seem niche, but when presented with their use-case, can help you perform your actions come to fruition. An expert is only as good as their creativity.',
            )}
            <Stack vertical>
              {data.expert.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item minWidth="33%">
          <Section title="Augmented">
            {descriptionBlock(
              'The flesh is weak; Augmented lets you tweak and adjust your physical body with specialized augments, granting you capabilities on-par with resonance, in a technological manner.\
              \n\nAugmented grants you augments at round-start, but is is beholden to a fair few restrictions and drawbacks; you can only have one augment per body part, and you are susceptible to EMPs, disabling your augments and possibly having adverse side-effects.\
              \n\nA subcategory of powers exists within Augmented; Premium Augments. These are commercialized and specialized augments made out of propieretary parts, making them unable to be built on the station. \
              These possess a quality meter, which dictates how much mileage you get out of your Premium Augments. The higher the percentage, the stronger their effects. \
              Through robotic surgery, these can be maintained and refurbished, restoring their quality. Once quality reaches 0%, you are required to refurbish it for it to be functional.\
              \nWhether you wish to burn through your augments and make repeat roboticist visits, or try to be more diligent with it, is up to you. Keep in mind as well; your powers can be physically stolen!',
            )}
            <Stack vertical>
              {data.augmented.map((val) => (
                <Powers key={val.icon} power={val} />
              ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Stack>
  );
};
