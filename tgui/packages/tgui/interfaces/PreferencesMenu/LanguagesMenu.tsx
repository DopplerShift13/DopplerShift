import { Box, Button, NumberInput, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { PreferencesMenuData } from './types';

export const KnownLanguage = (props) => {
  const { act } = useBackend<PreferencesMenuData>();
  return (
    <Stack.Item>
      <Section title={props.language.name}>
        {props.language.description}
        <br />
        <Button
          color="bad"
          onClick={() =>
            act('remove_language', { language_name: props.language.name })
          }
        >
          Forget <Box className={'languages16x16 ' + props.language.icon} />
        </Button>
        Understanding:
        <NumberInput
          width="30px"
          minValue={0}
          maxValue={100}
          step={0.5}
          value={props.language.partial_knowledge}
          onChange={(new_value) =>
            act('adjust_partial_language', {
              language_name: props.language.name,
              partial_amount: new_value,
            })
          }
        />
        %
      </Section>
    </Stack.Item>
  );
};

export const UnknownLanguage = (props) => {
  const { act } = useBackend<PreferencesMenuData>();
  return (
    <Stack.Item>
      <Section title={props.language.name}>
        {props.language.description}
        <br />
        <Button
          color="good"
          onClick={() =>
            act('give_language', { language_name: props.language.name })
          }
        >
          Learn <Box className={'languages16x16 ' + props.language.icon} />
        </Button>
      </Section>
    </Stack.Item>
  );
};

export const LanguagesPage = (props) => {
  const { data } = useBackend<PreferencesMenuData>();
  return (
    <Stack>
      <Stack.Item minWidth="33%">
        <Section title="Available Languages">
          <Stack vertical>
            {data.unselected_languages.map((val) => (
              <UnknownLanguage key={val.icon} language={val} />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item minWidth="33%">
        <Section
          title={
            'Points: ' +
            data.selected_languages.length +
            '/' +
            data.total_language_points
          }
        >
          Here, you can purchase languages using a point buy system. Each
          Language is worth 1 point.
        </Section>
      </Stack.Item>
      <Stack.Item minWidth="33%">
        <Section title="Known Languages">
          <Stack vertical>
            {data.selected_languages.map((val) => (
              <KnownLanguage key={val.icon} language={val} />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
