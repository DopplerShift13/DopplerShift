import {
  Box,
  Button,
  Dropdown,
  Image,
  Section,
  Stack,
} from 'tgui-core/components';

import { resolveAsset } from '../../assets';
import { useBackend } from '../../backend';
import type { PreferencesMenuData } from './types';

export const Powers = (props) => {
  const { act } = useBackend<PreferencesMenuData>();
  return (
    <Stack.Item
      style={{
        opacity: props.power.color,
      }}
    >
      <Section title={props.power.name}>
        {props.power.description}
        <br />
        <br />
        <b>{'Cost: ' + props.power.cost}</b>
        <br />
      </Section>
      <Stack mt={1}>
        <Stack.Item>
          <Button
            icon={props.power.powertype}
            color={props.power.state}
            tooltip={props.power.rootpower}
            tooltipPosition="right"
            onClick={() => {
              if (props.power.state === 'bad') {
                act('remove_power', { power_name: props.power.name });
              } else {
                act('give_power', { power_name: props.power.name });
              }
            }}
          >
            {props.power.word} <Box />
          </Button>
        </Stack.Item>
        <Stack.Item>
          {props.power.augment?.is_arm && props.power.has_power ? (
            <Box ml={1}>
              <Dropdown
                options={[
                  ...(props.power.augment?.left_blocked ? [] : ['Left']),
                  ...(props.power.augment?.right_blocked ? [] : ['Right']),
                  ...(!props.power.augment?.left_blocked &&
                  !props.power.augment?.right_blocked
                    ? ['Both']
                    : []),
                ]}
                selected={props.power.augment?.assignment}
                placeholder="Arm"
                disabled={
                  props.power.augment?.left_blocked &&
                  props.power.augment?.right_blocked
                }
                onSelected={(value) =>
                  act('set_augment_arm', {
                    power_name: props.power.name,
                    side: value,
                  })
                }
              />
            </Box>
          ) : props.power.augment?.location ? (
            <Box ml={1} color="label" fontSize="0.8em">
              ({props.power.augment?.location})
            </Box>
          ) : null}
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

type PowerPageProps = {
  handleOpenMortal: () => void;
  handleOpenSorcerous: () => void;
  handleOpenResonant: () => void;
};

function Gap(props: { amount: number }) {
  // 0.2em comes from the padding-bottom in the department listing
  return <Box height={`calc(${props.amount}px + 0.2em)`} />;
}

export const PowersPage = (props: PowerPageProps) => {
  const { data } = useBackend<PreferencesMenuData>();
  return (
    <Stack vertical>
      <Gap amount={80} />
      <Stack align="center" fill justify="center">
        <Stack.Item align="center" maxWidth="33%">
          <Stack align="center" vertical>
            <Image
              onClick={props.handleOpenSorcerous}
              src={resolveAsset('seal.png')}
              align="center"
              width={20}
            />
          </Stack>
          <Section align="center" title="The Sorcerous">
            In myths and fables, in times even before technology, particularly
            studious individuals learned how to unseam realities fabric with the
            song of the Resonance. Now, though the practices have changed and
            the myths faded, those dedicated, Sorcerous individuals still bend
            and break Natures will.
          </Section>
        </Stack.Item>
        <Stack.Item align="center" maxWidth="33%">
          <Stack align="center" vertical>
            <Image
              onClick={props.handleOpenResonant}
              src={resolveAsset('heart.png')}
              align="center"
              width={20}
            />
          </Stack>
          <Section align="center" title="The Resonant">
            Intense focus, and a spoon slowly bends. Deep meditation as the
            practicioner exhales fog with every breath, even though the room is
            warm. A baby born on the eclipse. Despite their differences, all
            these individuals are Resonant, and inherently flaunt Natures
            assertions.
          </Section>
        </Stack.Item>
        <Stack.Item align="center" maxWidth="33%">
          <Stack align="center" vertical>
            <Image
              onClick={props.handleOpenMortal}
              src={resolveAsset('gear.png')}
              align="center"
              width={20}
            />
          </Stack>
          <Section align="center" title="The Mortal">
            A man working the night-shift at a dull outpost. Another running
            through gunfire to save his comrade; later, that woman offering a
            folded flag to the man who saved her mother. A scientist pushing the
            edge of his field; a janitor mopping the floors of that same
            facility.
          </Section>
        </Stack.Item>
      </Stack>
    </Stack>
  );
};
