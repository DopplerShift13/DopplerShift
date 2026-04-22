import { ByondUi } from 'tgui-core/components';

export const CharacterPreview = (props: {
  width?: string; // DOPPLER SHIFT EDIT
  height: string;
  id: string;
}) => {
  // DOPPLER SHIFT ADDITION START
  const { width = '272px' } = props;
  // DOPPLER SHIFT ADDITION END
  return (
    <ByondUi
      width={width} // DOPPLER SHIFT EDIT
      height={props.height}
      params={{
        id: props.id,
        type: 'map',
      }}
    />
  );
};
